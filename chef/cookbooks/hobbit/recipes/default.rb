package "ruby-sass"
cookbook_file "#{Chef::Config[:file_cache_path]}/listen-0.7.3.gem" do
  source "listen-0.7.3.gem"
end
execute "install listen gem" do
  command "gem install #{Chef::Config[:file_cache_path]}/listen-0.7.3.gem"
end

# TODO: Use the real postgresql providers?
# include_recipe "database::postgresql"
execute "Install hobbit user" do
  command "createuser --superuser #{node[:runas]}"
  user "postgres"
  not_if "psql -U #{node[:runas]} -l"
end
# postgresql_database_user 'hobbit' do
#   username node[:runas]
#   superuser true
# end
execute "Create hobbit DB" do
  command "createdb -E UTF8 -T template0 hobbit"
  user "postgres"
  not_if "psql -U #{node[:runas]} hobbit -c 'SELECT 1;'"
end
# postgresql_database 'hobbit' do
#   encoding 'UTF-8'
#   owner node[:runas]
# end
