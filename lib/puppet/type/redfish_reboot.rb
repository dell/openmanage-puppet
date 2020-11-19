# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'redfish_reboot',
  docs: <<-EOS,
@summary a redfish_reboot type
@example
redfish_reboot { 'foo':
  ensure => 'present',
}

This type provides Puppet with the capabilities to manage ...

If your type uses autorequires, please document as shown below, else delete
these lines.
**Autorequires**:
* `Package[foo]`
EOS
  features: ['remote_resource'],
  attributes: {
    name: {
      type:      'String',
      desc:      'The name of the resource you want to manage.',
      behaviour: :namevar,
    },
    reboot: {
      type:      'Boolean',
      desc:      'The name of the resource you want to manage.',
    },
  },
)
