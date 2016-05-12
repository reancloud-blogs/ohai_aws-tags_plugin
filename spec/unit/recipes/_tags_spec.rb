require 'spec_helper'

describe 'chef_ohai_hints::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['ec2']['placement_availability_zone'] = 'us-east-1a'
      node.set['ohai']['plugin_path'] = '/etc/chef/ohai_plugins'
      node.set['aws']['tags'] = {
        'name' => 'ohai',
        'environment' => 'test'
      }
    end.converge(described_recipe)
  end

  it 'should install ruby' do
    expect(chef_run).to install_package('ruby')
  end

  it 'should install aws-sdk gem' do
    expect(chef_run).to install_chef_gem('aws-sdk')
  end

  it 'should create the ohai hints directory' do
    expect(chef_run).to create_directory('/etc/chef/ohai/hints')
  end

  it 'should create the ec2 ohai hints file' do
    expect(chef_run).to create_file('/etc/chef/ohai/hints/ec2.json')
  end

  it 'should create ohai plugin path' do
    expect(chef_run).to create_directory('/etc/chef/ohai_plugins')
  end

  it 'should create the awsext.rb file' do
    expect(chef_run).to create_cookbook_file('/etc/chef/ohai_plugins/awsext.rb')
  end

  it 'should not reload ohai by default' do
    expect(chef_run).to_not reload_ohai('reload_awsext')
  end

  it 'should notify reload ohai if plugin file exists' do
    resource = chef_run.cookbook_file('/etc/chef/ohai_plugins/awsext.rb')
    expect(resource).to notify('ohai[reload_awsext]').to(:reload).immediately
  end
end
