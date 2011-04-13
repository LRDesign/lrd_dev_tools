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
template "app/views/layouts/application.html.haml"
template "app/views/layouts/_nav.html.haml"
template "app/views/layouts/_flash.html.haml"

# template some more files
remove_file 'README'
template 'README'
# p source_paths
# copy_file 'README'
remove_file '.gitignore'
template 'dot.gitignore', '.gitignore'
remove_file 'config/database.yml'
template 'config/database.yml'
run 'cp config/database.yml config/database.yml.example'
run 'cp config/initializers/secret_token.rb config/initializers/secret_token.rb.example'
template 'config/initializers/smtp.rb'
run 'cp config/initializers/smtp.rb config/initializers/smtp.rb.example'
remove_file 'public/index.html'
directory 'spec'
directory 'lib'

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


# run installs
# run 'bundle install'
# run 'rails generate mizugumo:install'
# run 'rails generate rspec:install'

# TODO - LONG TERM below this line

# optionally install CMS engine
# template better 404/422/500 html

