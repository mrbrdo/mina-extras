namespace :puma do
  task :config do
    cmd_prefix  = "cd #{deploy_to}/#{current_path} ; "
    cmd_prefix += "RAILS_ENV=#{rails_env!} NEW_RELIC_DISPATCHER=puma bundle exec"
    set :puma_start_cmd, "#{cmd_prefix} puma -C #{File.join(deploy_to,current_path,'config','puma.rb')}"
    set :puma_stop_cmd, "#{cmd_prefix} pumactl -S #{deploy_to}/#{shared_path}/sockets/puma.state stop"
    set :puma_restart_cmd, "#{cmd_prefix} pumactl -S #{deploy_to}/#{shared_path}/sockets/puma.state phased-restart"
  end

  desc 'Start puma'
  task :start => [:config, :environment] do
    queue %{
      echo "-----> Starting puma"
      #{echo_cmd puma_start_cmd}
    }
  end

  desc 'Stop puma'
  task :stop => [:config, :environment] do
    queue %{
      echo "-----> Stopping puma"
      #{echo_cmd puma_stop_cmd}
    }
  end

  desc 'Restart puma'
  task :restart => [:config, :environment] do
    queue %{
      if [[ ! -e "#{deploy_to}/#{shared_path}/sockets/puma.state" || ! -e "#{deploy_to}/#{shared_path}/sockets/puma.sock" ]]; then
        echo "-----> Starting puma"
        #{echo_cmd puma_start_cmd}
      else
        echo "-----> Restarting puma"
        #{echo_cmd puma_restart_cmd}
      fi
    }
  end
end
