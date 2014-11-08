namespace :puma do
  task :config do
    set :puma_cmd_prefix, "cd #{deploy_to}/#{current_path} ; RAILS_ENV=#{rails_env!}"
    set :puma_pid_path, "#{deploy_to}/#{shared_path}/pids/puma.pid"
    set :puma_sock_dir, "#{deploy_to}/#{shared_path}/sockets"
    set :puma_start_cmd, "bundle exec puma -C #{File.join(deploy_to,current_path,'config','puma.rb')}"
    set :puma_stop_cmd, "bundle exec pumactl -S #{puma_sock_dir}/puma.state stop"
    set :puma_restart_cmd, "bundle exec pumactl -S #{puma_sock_dir}/puma.state phased-restart"
  end

  desc 'Start puma'
  task :start => [:config, :environment] do
    queue %{
      echo "-----> Starting puma"
      #{echo_cmd "#{puma_cmd_prefix} #{puma_start_cmd}"}
    }
  end

  desc 'Stop puma'
  task :stop => [:config, :environment] do
    queue %{
      echo "-----> Stopping puma"
      #{echo_cmd "#{puma_cmd_prefix} #{puma_stop_cmd}"}
    }
  end

  desc 'Restart puma'
  task :restart => [:config, :environment] do
    queue %{
      PUMA_PID=$(cat "#{puma_pid_path}")
      kill -0 $PUMA_PID > /dev/null 2>&1
      if [ $? != 0 ]; then
        rm "#{puma_sock_dir}/pumactl.sock" > /dev/null 2>&1
        rm "#{puma_sock_dir}/puma.sock" > /dev/null 2>&1
        echo "-----> Starting puma"
        #{echo_cmd "#{puma_cmd_prefix} #{puma_start_cmd}"}
      else
        echo "-----> Restarting puma"
        #{echo_cmd "#{puma_cmd_prefix} #{puma_restart_cmd}"}
      fi
    }
  end
end
