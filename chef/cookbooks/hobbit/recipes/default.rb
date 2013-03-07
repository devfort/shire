package "ruby-sass"

cookbook_file "#{Chef::Config[:file_cache_path]}/listen-0.7.3.gem" do
  source "listen-0.7.3.gem"
end
execute "install listen gem" do
  command "gem install #{Chef::Config[:file_cache_path]}/listen-0.7.3.gem"
end
