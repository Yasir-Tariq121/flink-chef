#
# Cookbook Name:: yasircookbook
# Recipe:: Get_S3
#

apt_package 'default-jdk' do
    action :install 
end
  
  
#Get S3 package
remote_file '/flink-1.11.1-bin-scala_2.11.tgz' do
    source "https://#{node['S3Bucket']['name']}/#{node['FlinkPkg']['name']}"
    mode '0777'
    action :create
end

bash 'flink-1.11.1' do
    user 'root'
    cwd '/'
    code <<-EOH
      tar -zxf flink-1.11.1-bin-scala_2.11.tgz
    EOH
  end


# Configure Flink
execute 'flink' do
    user "root"
    command 'sudo bash /flink-1.11.1/bin/start-cluster.sh'
    action :run
end