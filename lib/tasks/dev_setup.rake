require 'rake/tasklib'

namespace :dev do
  task :config_files

  task :setup => [
    "dev:config_files",
    "db:dev_install"
  ]

end

module LRD
  class ConfigFiles < Rake::TaskLib
    def initialize(name = :config_files, namespace = :dev)
      @name, @ns = name, namespace
      @root = Rails.root
      @names = %w{database.yml initializers/smtp.rb initializers/secret_token.rb}
      yield self if block_given?

      @config_dir ||= File::join(@root,"config")
      @files ||= make_files
      define
    end

    attr_accessor :root, :config_dir, :names, :files, :name, :ns

    def make_files
      @names.map do |name|
        File::join(@config_dir, name)
      end
    end

    def define
      @files.each do |path|
        file path => "#{path}.example" do
          copy "#{path}.example", path
        end
      end

      namespace @ns do
        desc "Set up sensitive files for local development"
        task @name => @files
      end
    end
  end
end


