# Authoring custom Ohai Plugins

## Repository Layout
While I imagine it would be easiest to have a single repository of custom Ohai plugins, instead of creating unique repositories for each plugin, it is useful to touch on how the code will be laid out.

    $ berks cookbook chef_ohai_hints

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

## Testing

This cookbook includes linting and automated testing using:

* [Rubocop](http://batsov.com/rubocop/)
* [Foodcritic](http://acrmp.github.io/foodcritic/)
* [ChefSpec](http://code.sethvargo.com/chefspec/)
* [ServerSpec](http://serverspec.org/)

These tests are triggered through a `rake` configuration by the following commands:

* `rake style`: Runs Rubocop and Foodcritic
* `rake spec`: Runs ChefSpec
* `rake integration:local`: Runs Test Kitchen and ServerSpec`

## Test Kitchen

This cookbook supports two Test Kitchen configurations:

* EC2: Mimics a production deployment by using Amazon EC2. This will use your credentials and default configuration in your `~/.aws` directory.
* Vagrant: For local testing. Uses CentOS 7.2 and Ubuntu 14.04.

### Kitchen Vagrant

The default Test Kitchen configuration used in this cookbook employs the Kitchen Vagrant driver.

Run `kitchen converge` as usual to create and converge the box.

### Kitchen EC2

To use the Kitchen EC2 configuration, set the following environment variables:

* `export KITCHEN_YAML=".kitchen.ec2.yml"`

* Testing the cookbook will incur AWS charges. Please be mindful of this when converging this Test Kitchen configuration and destroy the instance when not in use.
* Your AWS CLI credentials and configuration will be used. Ensure your credentials and configuration is present in `~/.aws/`.
* The ohai_test SSH key (ohai_test.pem) (also configurable in .kitchen.yml) is used for the created EC2 instance. The environment variable `ssh_key_path` should be set to the path to this key.
 * `export ssh_key_path="~/.ssh/path/to/key"`
