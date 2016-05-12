require 'spec_helper'

describe package('ruby') do
  it { should be_installed }
end

describe file('/etc/chef/ohai/hints') do
  it { should be_directory }
end

describe file('/etc/chef/ohai/hints/ec2.json') do
  it { should exist }
end

describe file('/etc/chef/ohai_plugins') do
  it { should be_directory }
end

describe file('/etc/chef/ohai_plugins/awsext.rb') do
  it { should exist }
end

describe command('ohai -d /etc/chef/ohai_plugins') do
  its(:stdout) { should contain('aws') }
end
