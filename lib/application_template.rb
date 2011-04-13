source_paths << File.expand_path('../templates', __FILE__)

gem 'haml'
gem 'mizugumo'
gem 'will_paginate', "~> 3.0.pre2"
gem 'populator'
gem 'faker'

gem 'rspec',              :group => "development test"
gem 'rspec-rails',        :group => "development test"
gem 'factory_girl_rails', :group => "development test"
gem 'webrat',             :group => 'development test'
gem 'ruby-debug'

gem 'annotate',      :group => 'development'
gem 'lrd_dev_tools', :group => 'development', :path => '../lrd_dev_tools'
gem 'mongrel',       :group => 'development'

# Delete prototype
inside('public/javascripts') do
  %w(controls.js dragdrop.js effects.js prototype.js rails.js).each{ |file|
    remove_file(file)
  }
end

# replace application.html with haml mizugumized version
inside 'app/views/layouts' do
  remove_file('application.html.erb')
end
template "application.html.haml", "app/views/layouts/application.html.haml"

# template some more files
remove_file '.gitignore'
template 'dot.gitignore', '.gitignore'
remove_file 'config/database.yml'
template 'database.yml', 'config/database.yml'
run 'cp config/database.yml config/database.yml.example'
run 'cp config/initializers/secret_token.rb config/initializers/secret_token.rb.example'
template 'smtp.rb', 'config/initializers/smtp.rb'
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

# remove test folder
remove_dir('test')

# # run bundle install
# run 'bundle install'
#
# # run mizugumo install
# run 'rails generate mizugumo:install'
#
# # run rspec install
# run 'rails generate rspec:install'

# template config/initializers/smtp.rb.example

# template README

# LONG TERM

# optionally install CMS engine
# template better 404/422/500 html

