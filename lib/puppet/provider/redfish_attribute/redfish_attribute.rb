# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

# Implementation for the redfish_attribute type using the Resource API.
class Puppet::Provider::RedfishAttribute::RedfishAttribute < Puppet::ResourceApi::SimpleProvider
  def get(context)
    instances = []

    attributes = context.device.get_bios_attributes

    return [] if attributes.nil?

    attributes.each do |attribute, value|
      instances << {   :name => attribute,
                       :value => value.to_s 
      }
    end

    instances
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
    context.device.set_bios_attribute( should )
  end

end
