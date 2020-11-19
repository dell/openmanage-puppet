# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

# Implementation for the redfish_firmware type using the Resource API.
class Puppet::Provider::RedfishFirmware::RedfishFirmware < Puppet::ResourceApi::SimpleProvider
  def get(context)
    version = context.device.get_firmware_version
    context.debug('Returning controller firmware version')
    [
      {
        name: 'controller',
        version: version.to_s,
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
    context.device.set_firmware_version( should[:url] )
  end
end
