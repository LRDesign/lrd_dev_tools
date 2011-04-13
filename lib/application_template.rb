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
  FileUtils.rm_rf %w(controls.js dragdrop.js effects.js prototype.js rails.js)
end

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

# replace application.html with haml version

# run mizugumo generator

