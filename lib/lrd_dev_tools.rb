module LRD::DevTools
  class Railtie < Rails::Railtie
    generators do
      # require 'generators/rspec/scaffold/scaffold_generator'
    end

    rake_tasks do
      Dir[File.expand_path("../tasks/**/*.rake", __FILE__)].each {|f| load f; puts "loading #{f}"}
    end
  end
end