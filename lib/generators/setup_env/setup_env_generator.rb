require 'bundler'

module Bundler
  module Generators
    class SetupEnv < Rails::Generators::Base
      namespace "setup_env"
      source_root(File::expand_path("../../../templates/bundler/setup_env", __FILE__))

      def create_setup_env
        template "setup_env.sh"
      end
    end
  end
end
