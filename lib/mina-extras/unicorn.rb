config_file_path = "#{File.join(fetch(:current_path),'config','unicorn.rb')}"
pid_path = "#{File.join(fetch(:current_path),'tmp','pids')}"
pid_file = "#{File.join(fetch(:pid_path),'unicorn.pid')}"

set :unicorn_start_cmd, lambda { "cd #{fetch(:current_path)} ; RAILS_ENV=#{fetch(:rails_env)} bundle exec unicorn -c #{fetch(:config_file_path)} -D -E production" }
set :unicorn_stop_cmd, lambda { "kill -s QUIT `cat #{fetch(:pid_file)}`" }
set :unicorn_terminate_cmd, lambda { "kill -s TERM `cat #{fetch(:pid_file)}`" }
set :unicorn_setup_cmd, lambda { "mkdir -p #{fetch(:pid_path)}" }

namespace :unicorn do
  desc 'Start Unicorn'
  task :start => [:environment] do
    command %{
      echo "------> Starting Unicorn"
      #{echo_cmd fetch(:unicorn_start_cmd)}
    }
  end

  desc 'Stop Unicorn'
  task :stop => [:environment] do
    command %{
      echo "------> Stopping Unicorn"
      #{echo_cmd fetch(:unicorn_stop_cmd)}
    }
  end

  desc 'Stop Unicorn'
  task 'force-stop' => [:environment] do
    command %{
      echo "------> Force stopping Unicorn"
      #{echo_cmd unicorn_terminate_cmd}
    }
  end

  desc 'Restart Unicorn'
  task :restart => [:environment] do
    command %{
      echo "------> Stopping Unicorn"
      #{echo_cmd fetch(:unicorn_stop_cmd)}
      echo "------> Starting Unicorn"
      #{echo_cmd fetch(:unicorn_start_cmd)}
    }
  end

  desc 'Setup paths'
  task :setup => [:environment] do
    command %{
      echo "------> creating pid folder"
      #{echo_cmd fetch(:unicorn_setup_cmd)}
    }
  end
end
