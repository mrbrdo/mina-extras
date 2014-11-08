config_file_path = "#{File.join(deploy_to,current_path,'config','unicorn.rb')}"
pid_path = "#{File.join(deploy_to,current_path,'tmp','pids')}"
pid_file = "#{File.join(pid_path,'unicorn.pid')}"

set_default :unicorn_start_cmd, lambda { "cd #{deploy_to}/#{current_path} ; RAILS_ENV=#{rails_env!} bundle exec unicorn -c #{config_file_path} -D -E production" }
set_default :unicorn_stop_cmd, lambda { "kill -s QUIT `cat #{pid_file}`" }
set_default :unicorn_terminate_cmd, lambda { "kill -s TERM `cat #{pid_file}`" }
set_default :unicorn_setup_cmd, lambda { "mkdir -p #{pid_path}" }

namespace :unicorn do
  desc 'Start Unicorn'
  task :start => [:environment] do
    queue %{
      echo "------> Starting Unicorn"
      #{echo_cmd unicorn_start_cmd}
    }
  end

  desc 'Stop Unicorn'
  task :stop => [:environment] do
    queue %{
      echo "------> Stopping Unicorn"
      #{echo_cmd unicorn_stop_cmd}
    }
  end

  desc 'Stop Unicorn'
  task 'force-stop' => [:environment] do
    queue %{
      echo "------> Force stopping Unicorn"
      #{echo_cmd unicorn_terminate_cmd}
    }
  end

  desc 'Restart Unicorn'
  task :restart => [:environment] do
    queue %{
      echo "------> Stopping Unicorn"
      #{echo_cmd unicorn_stop_cmd}
      echo "------> Starting Unicorn"
      #{echo_cmd unicorn_start_cmd}
    }  
  end

  desc 'Setup paths'
  task :setup => [:environment] do
    queue %{
      echo "------> creating pid folder"
      #{echo_cmd unicorn_setup_cmd}
    }
  end
end
