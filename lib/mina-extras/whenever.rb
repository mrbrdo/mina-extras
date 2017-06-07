# To use add to your deploy.rb
# set :whenever_identifier, "YOURAPP_#{rails_env!}"
# Add in "to :launch do"
#   invoke :'whenever:update_crontab'

set :whenever_environment,  lambda { fetch(:rails_env) }
set :whenever_variables,    lambda { "environment=#{fetch(:whenever_environment)}" }
set :whenever_command,      "bundle exec whenever"
set :whenever_update_flags, lambda { "--update-crontab #{fetch(:whenever_identifier)} --set #{fetch(:whenever_variables)}" }
set :whenever_clear_flags,  lambda { "--clear-crontab #{fetch(:whenever_identifier)}" }

namespace :whenever do
  desc "Update application's crontab entries using Whenever"
  task :update_crontab do
    queue! %[
      #{fetch(:whenever_command)} #{fetch(:whenever_update_flags)}
    ]
  end

  desc "Clear application's crontab entries using Whenever"
  task :clear_crontab do
    queue! %[
      #{fetch(:whenever_command)} #{fetch(:whenever_clear_flags)}
    ]
  end
end
