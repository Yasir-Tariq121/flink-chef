#
# Cookbook Name:: yasircookbook
# Recipe:: Get_S3
#

# apt_package 'default-jdk' do
#     action :install 
# end
  
  
# #Get S3 package
# remote_file '/flink-1.11.1-bin-scala_2.11.tgz' do
#     source "https://#{node['S3Bucket']['name']}/#{node['FlinkPkg']['name']}"
#     mode '0777'
#     action :create
# end

# #Extract package
# bash 'flink-1.11.1' do
#     user 'root'
#     cwd '/'
#     code <<-EOH
#       tar -zxf flink-1.11.1-bin-scala_2.11.tgz
#     EOH
#   end


# # Configure Flink
# execute 'flink' do
#     user "root"
#     command 'sudo bash /flink-1.11.1/bin/start-cluster.sh'
#     action :run
# end

package [ 'supervisor', 'default-jdk' ]
# apt_package 'default-jdk' do
#     action :install 
# end

remote_file '/tmp/flink-1.11.1-bin-scala_2.11.tgz' do
    source "https://#{node['s3Bucket']['name']}.s3.amazonaws.com/#{node['s3Bucket']['key']}"
    mode '0777'
    action :create
end

# tar_extract '/tmp/flink-1.11.1-bin-scala_2.11.tgz' do
#     action     :extract_local
#     target_dir "/"
#     tar_flags [ '-C' ]
# end

archive_file 'extract_Flink_pkg' do
    destination      '/'
    mode             '777'
    options          Array, Symbol
    path             '/tmp/flink-1.11.1-bin-scala_2.11.tgz' # default value: 'name' unless specified
end

template '/etc/systemd/system/flink.service' do
    source 'flink.service.erb'
    owner  'root'
    group  'root'
    mode   '0644'
    notifies :run,     'execute[systemd_reload]', :immediately
end

execute 'systemd_reload' do
    command 'systemctl daemon-reload'
    action  :nothing
end

template '/etc/supervisor/conf.d/flink-manager.conf' do
    source 'flink-manager/supervisor.erb'
    owner 'root'
    group 'root'
    mode '0744'
end

execute 'supervisor_start_flink' do
    command 'supervisorctl start flink'
    action :nothing
end