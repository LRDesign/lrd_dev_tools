source_paths.unshift File.expand_path('../templates/rails_app', __FILE__)

# clean up comments in the gemfile
gsub_file 'Gemfile', /(^#.*$)*/m, ''

gem 'haml'
gem 'mizugumo'
gem 'will_paginate', "~> 3.0.pre2"
gem 'populator'
gem 'faker'
gem 'mysql2'
gem 'lrd_view_tools', :path => '../lrd_view_tools'
gem 'rack-bug', :require => 'rack/bug', :git => 'git://github.com/brynary/rack-bug', :branch => 'rails3'

append_to_file('Gemfile') do
<<-EOTEXT

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'webrat'
  gem 'ruby-debug'
end

group :development do
  gem 'annotate'
  gem 'lrd_dev_tools', :path => '../lrd_dev_tools'
  gem 'mongrel'
end
EOTEXT
end

# make a staging environment
run 'cp config/environments/production.rb config/environments/staging.rb'

# add rack-bug to development & staging environments
['development', 'staging'].each do |env|
  require 'active_support/secure_random'
  secret_key = ActiveSupport::SecureRandom.hex(64)
  insert_into_file "config/environments/#{env}.rb", :after => "::Application.configure do\n" do
  <<-EOTEXT
  config.middleware.use 'Rack::Bug',
    :secret_key => '#{secret_key}',
    :panel_classes => [
       Rack::Bug::RailsInfoPanel,
       Rack::Bug::TimerPanel,
       Rack::Bug::RequestVariablesPanel,
       Rack::Bug::ActiveRecordPanel,
       Rack::Bug::TemplatesPanel,
       Rack::Bug::LogPanel,
       # Rack::Bug::SQLPanel,    # -- adds ~10 sec to load time
       # Rack::Bug::CachePanel,  # -- adds ~10 sec to load time
       Rack::Bug::MemoryPanel
     ]
EOTEXT
  end
end

# replace application.html with haml mizugumized version
inside 'app/views/layouts' do
  remove_file('application.html.erb')
end
directory "app/views/layouts"
directory "app/stylesheets"
directory "public/images"

# template some more files
remove_file 'README'
template 'README'
# p source_paths
# copy_file 'README'
remove_file '.gitignore'
template 'dot.gitignore', '.gitignore'
remove_file 'config/database.yml'
directory 'spec'
directory 'lib'
directory 'config'
run 'cp config/database.yml config/database.yml.example'
run 'cp config/initializers/secret_token.rb config/initializers/secret_token.rb.example'
run 'cp config/initializers/smtp.rb config/initializers/smtp.rb.example'
remove_file 'public/index.html'

# configure generators LRD-style
application do
  <<-EOTEXT
  config.generators do |g|
    g.template_engine     'mizugumo:haml'
    g.scaffold_controller 'mizugumo:scaffold_controller'
    g.test_framework      :lrdspec, :fixture => true
    g.fixture_replacement 'lrdspec:factory'

    g.fallbacks['mizugumo:haml']  = :haml
    g.fallbacks[:lrdspec] = :rspec
  end
EOTEXT
end

bundle_bin = nil
bundle_path = nil
if %x{which rvm}.empty? or /gem.*not set/ =~ %x{rvm info}
  if ENV['BUNDLE_BIN']
    bundle_bin = ENV['BUNDLE_BIN']
  elsif ENV['LRD_BUNDLE_BIN_ROOT']
    bundle_bin  = File::join(ENV['LRD_BUNDLE_BIN_ROOT'], File::basename(app_path), "bin")
    bundle_path = File::join(ENV['LRD_BUNDLE_BIN_ROOT'], "lib")
  else
    say("Not in a gemset, no BUNDLE_BIN set - gleefully installing to system", :yellow)
  end
end

#run installs
if bundle_bin or bundle_path
  say("Setting up BUNDLE_BIN as #{bundle_bin}", :blue)
  bundle_command = "bundle install"
  bundle_command += " --binstubs #{bundle_bin}" if bundle_bin
  bundle_command += " --path #{bundle_path}" if bundle_path

  run bundle_command
  run "rails generate setup_env"
else
  run 'bundle install'
end

run 'rails generate mizugumo:install'
run 'rails generate rspec:install'

# TODO - LONG TERM below this line

# optionally install CMS engine
# optionally install authlogic
# optionally install devise
# template better 404/422/500 html

# optionally install hoptoad
