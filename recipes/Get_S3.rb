#
# Cookbook Name:: yasircookbook
# Recipe:: Get_S3
#

# bucket_name = "YOUR_BUCKET_NAME"
# file_name = "FILE_NAME"

#Install java (required for Flink)
package 'oracle-java7-installer' do
    action :install
  end
  
  
  #Get S3 package
  remote_file '/flink-1.11.1-bin-scala_2.11.tgz' do
      source 'https://yasir-test-bucket.s3-us-west-2.amazonaws.com/flink-1.11.1-bin-scala_2.11.tgz'
      action :create
    end
  
  #Extract the Flink package
  archive_file 'extract_tar' do
      path   '/flink-1.11.1-bin-scala_2.11.tgz' 
      destination '/'
      action :extract
    end
  
  # Configure Flink
  execute "Flink" do
    command "sh /flink-1.11.1/flink-1.11.1/bin/start-cluster.sh"
  end