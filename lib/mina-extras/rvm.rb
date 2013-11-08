app_root = %x[pwd].strip

set :current_ruby, File.read("#{app_root}/.ruby-version").strip
set :current_gemset, File.read("#{app_root}/.ruby-gemset").strip

task :'rvm:use:current' do
  invoke :"rvm:use[#{current_ruby!}@#{current_gemset!}]"
end
