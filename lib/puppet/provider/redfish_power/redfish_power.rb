# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

# Implementation for the redfish_power type using the Resource API.
class Puppet::Provider::RedfishPower::RedfishPower < Puppet::ResourceApi::SimpleProvider
  def get(context)
    state = context.device.get_powerstate
    context.debug('Returning current power state')
    [
      {
        name: 'current',
        state: context.device.normalize( state ),
      },
    ]
  end

  def set(context, changes)
    changes.each do |name, change|
      if change[:is] != change[:should]
        update(context, name, change[:should])
      end
    end
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
    state = context.device.camelize( should[:state] )
    context.device.set_powerstate( state )
  end
end