#
# Cookbook Name:: chef-ohai-hints
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'ohai'

apt_repository 'ruby-ng' do
  uri     'ppa:brightbox/ruby-ng'
  distribution node['lsb']['codename']
end

apt_update 'update' do
  action :nothing
  subscribes :update, 'apt_repository[ruby-ng]' :immediately
end

package 'ruby2.2'

package 'aws-sdk'  do
  action :install
  provider 'chef_gem'
end

file '/etc/chef/ohai/hints/ec2.json' do
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

ohai 'reload_awsext' do
  plugin 'awsext'
  action :nothing
end

['awsext', ''].each do |plugin|
  cookbook_file "#{node[:ohai][:plugin_path]}/#{plugin}.rb" do
    source "files/default/plugins/#{plugin}.rb"
    notifies :reload, "ohai[reload #{plugin}]"
  end
end
