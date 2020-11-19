# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'redfish_job',
  docs: <<-EOS,
@summary a redfish_job type
@example
redfish_job { 'foo':
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
    apply: {
      type:    'Enum[yes, no]',
      desc:    'Whether this resource should be applied on the target system.',
      default: 'present',
    },
    name: {
      type:      'String',
      desc:      'The name of the resource you want to manage.',
      behaviour: :namevar,
    },
  },
)
