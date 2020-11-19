# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

# Implementation for the redfish_reboot type using the Resource API.
class Puppet::Provider::RedfishReboot::RedfishReboot < Puppet::ResourceApi::SimpleProvider
  def get(context)
    context.debug('Returning pre-canned example data')
    [
      {
        name: 'save_bios',
        reboot: false,
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
    context.device.set_apply_reboot
  end
end
