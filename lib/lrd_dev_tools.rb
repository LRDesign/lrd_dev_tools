
module LRD::DevTools
  class Railtie < Rails::Railtie

    config.respond_to?(:app_generators) ? config.app_generators : config.generators do |generators|
      generators.templates.unshift File::expand_path('../templates', __FILE__)
    end

    # We have to configure our test_framework and fixture_replacement in an initializer
    # because FactoryGirl rudely overwrites any test_framework that doesn't == :rspec with
    # :test_unit.  Boo.
    initializer "lrd_dev_tools.set_generators", :after => 'factory_girl.set_fixture_replacement' do
      generators = config.respond_to?(:app_generators) ? config.app_generators : config.generators
      generators.template_engine     'mizugumo:haml'
      generators.scaffold_controller 'mizugumo:scaffold_controller'
      generators.assets              'mizugumo:js_assets'

      generators.test_framework :lrdspec, :fixture => true
      generators.fixture_replacement 'lrdspec:factory'

      generators.fallbacks['mizugumo:haml']  = :haml
      generators.fallbacks[:lrdspec] = :rspec
    end

    rake_tasks do
      Dir[File.expand_path("../tasks/**/*.rake", __FILE__)].each {|f| load f }
    end
  end
end


