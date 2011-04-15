namespace :dev do

  desc "Set up sensitive files (database.yml etc.)for local development"
  task :config_files  do
    root = Rails.root
    [ 'database.yml', 'initializers/smtp.rb', 'initializers/secret_token.rb'].each do |file|
      sh "cp #{root}/config/#{file}.example #{root}/config/#{file}"
    end
  end

end
