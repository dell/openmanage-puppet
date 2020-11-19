# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_transport(
  name: 'redfish',
  desc: <<-EOS,
      This transport provides Puppet with the capability to connect to redfish targets.
    EOS
  features: ['remote_resource'],
  connection_info: {
    hostname: {
      type: 'String',
      desc: 'The hostname or IP address to connect to for this target.',
    },
    username: {
      type: 'String',
      desc: 'The name of the user to authenticate as.',
    },
    password: {
      type:      'String',
      desc:      'The password for the user.',
      sensitive: true,
    },
  },
)
