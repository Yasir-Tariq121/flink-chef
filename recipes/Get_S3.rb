#
# Cookbook Name:: yasircookbook
# Recipe:: Get_S3
#

# bucket_name = "YOUR_BUCKET_NAME"
# file_name = "FILE_NAME"

#Install java (required for Flink)
# package 'oracle-java7-installer' do
#     action :install
# end
apt_package 'default-jdk' do
    action :install # defaults to :install if not specified
end
  
  
#Get S3 package
remote_file '/flink-1.11.1-bin-scala_2.11.tgz' do
    source 'https://yasir-test-bucket.s3-us-west-2.amazonaws.com/flink-1.11.1-bin-scala_2.11.tgz'
    mode '0777'
    action :create
end

#Extract the Flink package
# archive_file 'flink-1.11.1' do
#     path   '/flink-1.11.1-bin-scala_2.11.tgz' 
#     destination '/'
#     action :extract
# end
# execute "extract" do
#     command "sh tar -xvf /flink-1.11.1-bin-scala_2.11.tgz"
# end
bash 'flink-1.11.1' do
    user 'root'
    cwd '/'
    code <<-EOH
      tar -zxf flink-1.11.1-bin-scala_2.11.tgz
      cd flink-1.11.1/flink-1.11.1/bin
      start-cluster.sh
    EOH
  end

# # Configure Flink
# execute "Flink" do
#     command "sh /flink-1.11.1/flink-1.11.1/bin/start-cluster.sh"
# end