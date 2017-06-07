set :puma_cmd_prefix, lambda { "cd #{fetch(:current_path)} ; RAILS_ENV=#{fetch(:rails_env)}" }
set :puma_pid_path, lambda { "#{fetch(:shared_path)}/pids/puma.pid" }
set :puma_sock_dir, lambda { "#{fetch(:shared_path)}/sockets" }
set :puma_start_cmd, lambda { "bundle exec puma -C #{File.join(fetch(:current_path),'config','puma.rb')}" }
set :puma_stop_cmd, lambda { "bundle exec pumactl -S #{fetch(:puma_sock_dir)}/puma.state stop" }
set :puma_restart_cmd, lambda { "bundle exec pumactl -S #{fetch(:puma_sock_dir)}/puma.state phased-restart" }

namespace :puma do
  desc 'Start puma'
  task :start => [:environment] do
    command %{
      echo "-----> Starting puma"
      #{echo_cmd "#{fetch(:puma_cmd_prefix)} #{fetch(:puma_start_cmd)}"}
    }
  end

  desc 'Stop puma'
  task :stop => [:environment] do
    command %{
      echo "-----> Stopping puma"
      #{echo_cmd "#{fetch(:puma_cmd_prefix)} #{fetch(:puma_stop_cmd)}"}
    }
  end

  desc 'Restart puma'
  task :restart => [:environment] do
    command %{
      PUMA_PID=$(cat "#{fetch(:puma_pid_path)}" 2>/dev/null)
      kill -0 $PUMA_PID > /dev/null 2>&1
      if [ $? != 0 ]; then
        rm "#{fetch(:puma_sock_dir)}/pumactl.sock" > /dev/null 2>&1
        rm "#{fetch(:puma_sock_dir)}/puma.sock" > /dev/null 2>&1
        echo "-----> Starting puma"
        #{echo_cmd "#{fetch(:puma_cmd_prefix)} #{fetch(:puma_start_cmd)}"}
      else
        echo "-----> Restarting puma"
        #{echo_cmd "#{fetch(:puma_cmd_prefix)} #{fetch(:puma_restart_cmd)}"}
      fi
    }
  end
end
