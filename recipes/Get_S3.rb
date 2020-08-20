#
# Cookbook Name:: yasircookbook
# Recipe:: Get_S3
#
package [ 'supervisor', 'default-jdk' ]

remote_file '/tmp/flink-1.11.1-bin-scala_2.11.tgz' do
    source "https://#{node['s3Bucket']['name']}.s3.amazonaws.com/#{node['s3Bucket']['key']}"
    mode '0777'
    action :create
end

execute 'extract_flink' do
    command 'tar zxvf /tmp/flink-1.11.1-bin-scala_2.11.tgz -C /'
    action :run
end