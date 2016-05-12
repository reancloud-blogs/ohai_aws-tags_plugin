name             'chef_ohai_hints'
maintainer       'Matt Karmazyn'
maintainer_email 'matthew.karmazyn@reancloud.com'
license          'All rights reserved'
description      'Installs/Configures chef_ohai_hints'
long_description 'Installs/Configures chef_ohai_hints'
version          '0.2.0'

depends 'ohai'
depends 'apt', '~> 3.0.0'

%w( amazon centos oracle redhat debian ubuntu ).each { |os| supports os }

url = 'https://github.com/reancloud'
issues_url "#{url}/chef_ohai_hints/issues" if respond_to?(:issues_url)
source_url "#{url}/chef_ohai_hints" if respond_to?(:source_url)
