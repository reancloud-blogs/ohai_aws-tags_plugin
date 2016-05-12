require 'chef/cookbook/metadata'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'

metadata = Chef::Cookbook::Metadata.new
metadata.from_file('metadata.rb')

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any']
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# Rspec and ChefSpec
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen locally'
  task :local do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(
      project_config: './.kitchen.yml'
    )
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end

  desc 'Run Test Kitchen on EC2'
  task :ec2 do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(
      project_config: './.kitchen.ec2.yml'
    )
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end

  desc 'Run Test Kitchen on Jenkins'
  task :jenkins do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(
      project_config: './.kitchen.jenkins.yml'
    )
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end
end

task :supermarket do
  system "knife supermarket share #{metadata.name} \"Other\" -o ../."
end

# Jenkins
desc 'Run all tests on jenkins'
task jenkins: %w(style spec supermarket)

# Default
desc 'Run all tests locally'
task default: %w(style spec integration:local)

# Jenkins
desc 'Run all tests on jenkins'
task ec2: %w(style spec integration:ec2)
