source_paths.unshift File.expand_path('../templates/rails_app', __FILE__)

gem 'haml'
gem 'mizugumo'
gem 'will_paginate', "~> 3.0.pre2"
gem 'populator'
gem 'faker'
gem 'mysql2'

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

# replace application.html with haml mizugumized version
inside 'app/views/layouts' do
  remove_file('application.html.erb')
end
template "app/views/layouts/application.html.haml"
template "app/views/layouts/_nav.html.haml"
template "app/views/layouts/_flash.html.haml"
directory "app/stylesheets"

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
if %x{which rvm}.empty? or /gem.*not set/ =~ %w{rvm info}
  if ENV['BUNDLE_BIN']
    bundle_bin = ENV['BUNDLE_BIN']
  elsif ENV['LRD_BUNDLE_BIN_ROOT']
    bundle_bin = File::join(ENV['LRD_BUNDLE_BIN_ROOT'], File::basename(app_path), "bin")
  else
    say("Not in a gemset, no BUNDLE_BIN set - gleefully installing to system", :yellow)
  end
end

# run installs
if bundle_bin
  say("Setting up BUNDLE_BIN as #{bundle_bin}", :blue) 
  run "bundle install --binstubs #{bundle_bin}"
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
