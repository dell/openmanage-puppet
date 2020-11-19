# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'redfish_power',
  docs: <<-EOS,
@summary a redfish_power type
@example
redfish_power { 'foo':
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
    state: {
      type:    'Enum[on, force_off, force_restart, graceful_shutdown, nmi]',
      desc:    'Whether this resource should be present or absent on the target system.',
    },
    name: {
      type:      'String',
      desc:      'The name of the resource you want to manage.',
      behaviour: :namevar,
    },
  },
)