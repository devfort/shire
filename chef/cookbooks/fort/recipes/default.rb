cookbook_file "/etc/apt/sources.list.d/fort.list" do
  source "apt/fort.list"
  mode 0644
  owner "root"
  group "root"
  notifies :run, "execute[apt-get-update]", :immediate
end

execute "apt-get-update" do
  command "apt-get update"
  action :nothing
end

directory "/home/#{node[:runas]}/.pip" do
  owner node[:runas]
  group node[:runas]
  mode 0755
end

cookbook_file "/home/#{node[:runas]}/.pip/pip.conf" do
  source "pypi/pip.conf"
  owner node[:runas]
  group node[:runas]
  mode 0755
end

cookbook_file "/home/#{node[:runas]}/.npmrc" do
  source "npm/npmrc"
  owner node[:runas]
  group node[:runas]
  mode 0755
end

remote_directory "/usr/etc/postgresql" do
  source "postgres/etc"
end

bash "remove broken postgres" do
  code <<-EOH
  pkill postgres
  sed -i -e '/pg_ctl/d' /etc/rc.local
  EOH
end

cookbook_file "/etc/init/postgres.conf" do
  source "postgres/upstart.conf"
  notifies :restart, "service[postgres]", :immediate
end

service "postgres" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

#
# Install local mail delivery and MTA
#
# The metapackage mail-stack-delivery will set up local IMAP/POP/SMTP servers
# that, by default, will authenticate using PAM.
#

cookbook_file "/var/tmp/postfix.preseed" do
  source "mail-stack-delivery/postfix.preseed"
  notifies :run, "execute[set postfix selections]", :immediately
end

execute "set postfix selections" do
  command "debconf-set-selections /var/tmp/postfix.preseed"
  action :nothing
end

package "mail-stack-delivery"
