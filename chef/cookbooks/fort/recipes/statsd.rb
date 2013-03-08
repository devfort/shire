package "graphite-carbon"

user node[:statsd][:user] do
  home "/home/#{node[:statsd][:user]}"
  supports :manage_home => true
end

# TODO: Install from npm
{
  'statsd'      => "statsd-0.5.0.tgz",
  'node-syslog' => "node-syslog-1.1.3.tar",
}.each { |package, package_file|
  if `test -d /home/#{node[:statsd][:user]}/node_modules/#{package}`
    cookbook_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
      source "statsd/#{package_file}"
      owner node[:statsd][:user]
      group node[:statsd][:user]
      mode 0755
    end
    execute "install #{package}" do
      command "npm install #{Chef::Config[:file_cache_path]}/#{package_file}"
      user node[:statsd][:user]
      cwd "/home/#{node[:statsd][:user]}"
      environment ({"HOME" => "/home/#{node[:statsd][:user]}"})
    end
  end
}


directory "/home/#{node[:statsd][:user]}/etc" do
  owner node[:statsd][:user]
  group node[:statsd][:user]
  mode 0755
end

cookbook_file "/etc/default/graphite-carbon" do
  source "statsd/graphite-carbon"
  owner node[:statsd][:user]
  group node[:statsd][:user]
  mode 0644
  notifies :restart, "service[carbon-cache]", :immediate
end

service "carbon-cache" do
  action [:enable, :start]
end

{
  "statsd/upstart.conf.erb" => "/etc/init/statsd.conf",
  "statsd/config.js.erb"    => "/home/#{node[:statsd][:user]}/etc/config.js"
}.each{ |source, target|
  template target do
    source source
    owner node[:statsd][:user]
    group node[:statsd][:user]
    mode  0644
    notifies :restart, "service[statsd]", :immediate
  end
}

service "statsd" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
