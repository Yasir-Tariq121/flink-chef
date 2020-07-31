#
# Cookbook Name:: yasircookbook
# Recipe:: update
#

# apt_package 'default-jdk' do
#     action :install 
# end
  


#Stop Flink
execute 'flink_stop' do
    user "root"
    command 'sudo bash /flink-1.11.1/bin/stop-cluster.sh'
    action :run
end
#Get S3 updated package
remote_file '/Updated-Flink.tgz' do
    source "https://#{node['S3Bucket']['name']}/#{node['Flink_Updated_Pkg']['name']}"
    mode '0777'
    action :create
end

#Extract package
bash 'Updated_Flink' do
    user 'root'
    cwd '/'
    code <<-EOH
      tar -zxf Updated-Flink.tgz
      mv /Updated-Flink/conf/flink-conf.yaml /flink-1.11.1/conf
      mv /Updated-Flink/conf/log4j.properties /flink-1.11.1/conf
    EOH
  end


# Configure Flink
execute 'flink' do
    user "root"
    command 'sudo bash /flink-1.11.1/bin/start-cluster.sh'
    action :run
end