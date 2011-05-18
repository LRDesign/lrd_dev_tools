module LRD::DevTools
  class Railtie < Rails::Railtie
    config.generators do |g|
      g.templates.unshift File::expand_path('../templates', __FILE__)
    end

    rake_tasks do
      Dir[File.expand_path("../tasks/**/*.rake", __FILE__)].each {|f| load f }
    end
  end
end
