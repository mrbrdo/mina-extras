set_default :puma_cmd_prefix, lambda { "cd #{deploy_to}/#{current_path} ; RAILS_ENV=#{rails_env!}" }
set_default :puma_pid_path, lambda { "#{deploy_to}/#{shared_path}/pids/puma.pid" }
set_default :puma_sock_dir, lambda { "#{deploy_to}/#{shared_path}/sockets" }
set_default :puma_start_cmd, lambda { "bundle exec puma -C #{File.join(deploy_to,current_path,'config','puma.rb')}" }
set_default :puma_stop_cmd, lambda { "bundle exec pumactl -S #{puma_sock_dir}/puma.state stop" }
set_default :puma_restart_cmd, lambda { "bundle exec pumactl -S #{puma_sock_dir}/puma.state phased-restart" }

namespace :puma do
  desc 'Start puma'
  task :start => [:environment] do
    queue %{
      echo "-----> Starting puma"
      #{echo_cmd "#{puma_cmd_prefix} #{puma_start_cmd}"}
    }
  end

  desc 'Stop puma'
  task :stop => [:environment] do
    queue %{
      echo "-----> Stopping puma"
      #{echo_cmd "#{puma_cmd_prefix} #{puma_stop_cmd}"}
    }
  end

  desc 'Restart puma'
  task :restart => [:environment] do
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
