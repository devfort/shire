package "graphite-carbon"

user "statsd" do
  home "/home/statsd"
  supports :manage_home => true
end

# TODO: Install node-syslog from npm
if `test -d /home/#{node[:statsd][:user]}/node_modules/statsd`
  cookbook_file "#{Chef::Config[:file_cache_path]}/statsd-0.5.0.tgz" do
    source "statsd/statsd-0.5.0.tgz"
    owner node[:statsd][:user]
    group node[:statsd][:user]
    mode 0755
  end
  execute "install statsd" do
    command "npm install #{Chef::Config[:file_cache_path]}/statsd-0.5.0.tgz"
    user node[:statsd][:user]
    cwd "/home/#{node[:statsd][:user]}"
    environment ({"HOME" => "/home/#{node[:statsd][:user]}"})
  end
end

cookbook_file "/etc/init/statsd.conf" do
  source "statsd/upstart.conf"
  notifies :restart, "service[statsd]", :immediate
end

service "statsd" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
