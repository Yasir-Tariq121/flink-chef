#
# Cookbook Name:: yasircookbook
# Recipe:: update
#

template 'Flink_conf' do
  source 'flink-conf.yaml.erb'
  owner 'root'
  group 'root'
  mode '0777'
  path '/flink-1.11.1/conf/flink-conf.yaml'
end

template 'Log4j_conf' do
  source 'log4j.properties.erb'
  owner 'root'
  group 'root'
  mode '0777'
  path '/flink-1.11.1/conf/log4j.properties'
end

template "/etc/supervisor/conf.d/flink.ini" do
  source "supervisor.ini.erb"
  mode   0644
  notifies :run, "execute[supervisor_reload]", :immediately
  notifies :run, "execute[supervisor_flink_restart]", :immediately
end


execute 'supervisor_flink_restart' do
  command 'supervisorctl restart all'
  action :run
end
execute 'supervisor_reload' do
  command 'supervisorctl reload'
  action :run
end