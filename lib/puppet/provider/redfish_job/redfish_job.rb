# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

# Implementation for the redfish_job type using the Resource API.
class Puppet::Provider::RedfishJob::RedfishJob < Puppet::ResourceApi::SimpleProvider
  def get(context)
    context.debug('Returning data')
    [
      {
        name: 'bios',
        apply: 'no',
      },
    ]
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
    context.device.set_bios_job
  end

  def set(context, changes)
    changes.each do |name, change|
      if change[:is] != change[:should]
        update(context, name, change[:should])
      end
    end
  end

end
