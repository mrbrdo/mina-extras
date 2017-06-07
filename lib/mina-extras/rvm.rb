app_root = %x[pwd].strip

version = File.read("#{app_root}/.ruby-version").strip
if File.exist?("#{app_root}/.ruby-gemset")
  gemset = File.read("#{app_root}/.ruby-gemset").strip
else
  version, gemset = version.split("@")
end
set :current_ruby, version
set :current_gemset, gemset

task :'rvm:use:current' do
  invoke :"rvm:use", "#{fetch(:current_ruby)}@#{fetch(:current_gemset)}"
end
