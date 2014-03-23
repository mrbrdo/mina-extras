namespace :unicorn do
  task :config do
    cmd_prefix  = "cd #{deploy_to}/#{current_path} ; "
    cmd_prefix += "RAILS_ENV=#{rails_env!} bundle exec"
    config_file_path = "#{File.join(deploy_to,current_path,'config','unicorn.rb')}"
    pid_path = "#{File.join(deploy_to,current_path,'tmp','pids')}"
    pid_file = "#{File.join(pid_path,'unicorn.pid')}"
    
    set :unicorn_start_cmd, "#{cmd_prefix} unicorn -c #{config_file_path} -D -E production"
    set :unicorn_stop_cmd, "kill -s QUIT `cat #{pid_file}`"
    set :unicorn_terminate_cmd, "kill -s TERM `cat #{pid_file}`"
    set :unicorn_setup_cmd, "mkdir -p #{pid_path}"
  end

  desc 'Start Unicorn'
  task :start => [:config, :environment] do
    queue %{
      echo "------> Starting Unicorn"
      #{echo_cmd unicorn_start_cmd}
    }
  end

  desc 'Stop Unicorn'
  task :stop => [:config, :environment] do
    queue %{
      echo "------> Stopping Unicorn"
      #{echo_cmd unicorn_stop_cmd}
    }
  end

  desc 'Stop Unicorn'
  task 'force-stop' => [:config, :environment] do
    queue %{
      echo "------> Force stopping Unicorn"
      #{echo_cmd unicorn_terminate_cmd}
    }
  end

  desc 'Restart Unicorn'
  task :restart => [:config, :environment] do
    queue %{
      echo "------> Stopping Unicorn"
      #{echo_cmd unicorn_stop_cmd}
      echo "------> Starting Unicorn"
      #{echo_cmd unicorn_start_cmd}
    }  
  end

  desc 'Setup paths'
  task :setup => [:config, :environment] do
    queue %{
      echo "------> creating pid folder"
      #{echo_cmd unicorn_setup_cmd}
    }
  end

end
