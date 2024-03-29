require 'generators/rspec'

# Try to force it to require the file from the rspec gem
require 'generators/rspec/mailer/../scaffold/scaffold_generator'
require 'rails/generators/resource_helpers'

module Lrdspec
  module Generators
    class ScaffoldGenerator < Rspec::Generators::ScaffoldGenerator
      source_paths << File.expand_path('../templates', __FILE__)

      protected
      # replace copy view with one that explicitly doesn't put the
      # template engine in the file name
      def copy_view(view)
        template "#{view}.html_spec.rb",
                 File.join("spec/views", controller_file_path, "#{view}.html_spec.rb")
      end
    end
  end
end
