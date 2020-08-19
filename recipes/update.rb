#
# Cookbook Name:: yasircookbook
# Recipe:: update
#

# apt_package 'default-jdk' do
#     action :install 
# end
  


# #Stop Flink
# execute 'flink_stop' do
#     user "root"
#     command 'sudo bash /flink-1.11.1/bin/stop-cluster.sh'
#     action :run
# end
# #Get S3 updated package
# remote_file '/Updated-Flink.tgz' do
#     source "https://#{node['S3Bucket']['name']}/#{node['Flink_Updated_Pkg']['name']}"
#     mode '0777'
#     action :create
# end

# #Extract package
# bash 'Updated_Flink' do
#     user 'root'
#     cwd '/'
#     code <<-EOH
#       tar -zxf Updated-Flink.tgz
#     EOH
#   end
# #Move conf.yaml
# execute 'move conf' do
#   user "root"
#   command 'sudo mv /Updated_Flink/conf/flink-conf.yaml /flink-1.11.1/conf'
#   action :run
# end
# #Move log file
# execute 'move log' do
#   user "root"
#   command 'sudo mv /Updated_Flink/conf/log4j.properties /flink-1.11.1/conf'
#   action :run
# end


# # Configure Flink
# execute 'flink' do
#     user "root"
#     command 'sudo bash /flink-1.11.1/bin/start-cluster.sh'
#     action :run
# end



package [ 'supervisor', 'unzip' ]


execute 'supervisor_stop_flink' do
    command 'supervisorctl stop flink'
    action :nothing
end

# remote_file '/tmp/flink-1.11.1-bin-scala_2.11.tgz' do
#     source "https://#{node['s3Bucket']['name']}.s3.amazonaws.com/#{node['s3Bucket']['key']}"
#     mode '0777'
#     action :create
# end


# tar_extract '/tmp/flink-1.11.1-bin-scala_2.11.tgz' do
#     action     :extract_local
# end

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

execute 'supervisor_start_flink' do
    command 'supervisorctl start flink'
    action :nothing
end