# Authoring custom Ohai Plugins

## Repository Layout
While I imagine it would be easiest to have a single repository of custom Ohai plugins, instead of creating unique repositories for each plugin, it is useful to touch on how the code will be laid out.

    $ berks cookbook chef-ohai-hints

The Berkshelf utility (available from the ChefDK package) will create a repository structure that will be suitable for our needs.

We will be using the following locations within the standard repo layout created by Berkshelf.

    - Berksfile                 => Location for storing cookbook dependencies
    - files/default/plugins/    => Default file path for custom_plugin.rb files
    - recipies/default.rb       => Default recipe for adding dependencies and staging custom_plugins in ohai
    - test/integration/default/ => Default path for spec tests
    - .kitchen.yml              => Location for automated test configuration w/ KitchenSpec

## Satisfying System Dependencies

It stands to reason that if you’re writing custom Ohai plugins, that you’re likely using resources not normally installed on a base system. For that reason, it makes sense to have to add in a little chef code to stage your dependencies.

In our example, we will be authoring some additional information about an EC2 instance, which are not available in the metadata (covered by the ec2 plugin in Ohai).

### recipes/default.rb

    package 'aws-sdk'  do
      action :install
      provider 'chef_gem'
    end

While we’re here, we may as well add in a quick resource to ensure that the standard ec2 plugin will populate inside a VPC.

    file '/etc/chef/ohai/hints/ec2.json' do
      owner 'root'
      group 'root'
      mode 00755
      action :create
    end



