#
# Cookbook Name:: chef_ohai_hints
# Recipe:: default
#
# Copyright (C) 2016 Rean Cloud Solutions
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ohai'

# Install ruby (and rubygems)
package 'ruby2.2' do
  package_name 'ruby2.2'
  action :install
end

# Install the ruby aws sdk
chef_gem 'aws-sdk' do
  compile_time false if respond_to?(:compile_time)
  action :install
end

# Create the ohai hints directory
directory '/etc/chef/ohai/hints' do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
  action :create
end

# Touch the ec2 hints file so ohai picks up the default ec2 metadata
file '/etc/chef/ohai/hints/ec2.json' do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

# Create the ohai plugin path directory
directory node['ohai']['plugin_path'] do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
  action :create
end

# Reload ohai data when cookbook_file is placed on node
ohai 'reload_awsext' do
  action :nothing
  retries 0
  retry_delay 2
  plugin 'awsext'
end

# Place each file in the ohai plugin path on the node
# ['awsext', ''].each do |plugin|
cookbook_file "#{node['ohai']['plugin_path']}/awsext.rb" do
  source 'default/plugins/awsext.rb'
  action :create
  owner 'root'
  group 'root'
  mode 0644
  notifies :reload, 'ohai[reload_awsext]', :immediately
end
# end

# Log our tags at the end of the run for debugging purposes
# log 'aws tags' do
#   message "aws tags: #{node['aws']['tags']}"
#   level :info
# end
