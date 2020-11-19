# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'redfish_attribute',
  docs: <<-EOS,
@summary a redfish_attribute type
@example
redfish_attribute { 'foo':
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
    value: {
      type:      'String',
      desc:      'The value of the resource you want to manage.',
    },
  },
)
