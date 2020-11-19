# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'redfish_firmware',
  docs: <<-EOS,
@summary a redfish_firmware type
@example
redfish_firmware { 'foo':
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
    version: {
      type:      'String',
      desc:      'The version of the resource you want to manage.',
      behaviour: :read_only,
    },
    url: {
      type:      'Optional[String]',
      desc:      'The url of the resource you want to manage.',
    },
  },
)
