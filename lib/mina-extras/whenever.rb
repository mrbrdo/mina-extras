# To use add to your deploy.rb
# set :whenever_identifier, "YOURAPP_#{rails_env!}"
# Add in "to :launch do"
#   invoke :'whenever:update_crontab'

set_default :whenever_environment,  lambda { rails_env! }
set_default :whenever_variables,    lambda { "environment=#{whenever_environment!}" }
set_default :whenever_command,      "bundle exec whenever"
set_default :whenever_update_flags, lambda { "--update-crontab #{whenever_identifier!} --set #{whenever_variables!}" }
set_default :whenever_clear_flags,  lambda { "--clear-crontab #{whenever_identifier!}" }

namespace :whenever do
  desc "Update application's crontab entries using Whenever"
  task :update_crontab do
    queue! %[
      #{whenever_command!} #{whenever_update_flags!}
    ]
  end

  desc "Clear application's crontab entries using Whenever"
  task :clear_crontab do
    queue! %[
      #{whenever_command!} #{whenever_clear_flags!}
    ]
  end
end
