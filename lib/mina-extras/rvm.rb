app_root = %x[pwd].strip

version = File.read("#{app_root}/.ruby-version").strip
if File.exist?("#{app_root}/.ruby-gemset")
  gemset = File.read("#{app_root}/.ruby-gemset").strip
else
  version, gemset = version.split("@")
end
set_default :current_ruby, version
set_default :current_gemset, gemset

task :'rvm:use:current' do
  invoke :"rvm:use[#{current_ruby!}@#{current_gemset!}]"
end
