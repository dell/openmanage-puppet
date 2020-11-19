# frozen_string_literal: true

require 'redfish_client'
require 'pp'

module Puppet::Transport
  # The main connection class to a Redfish endpoint
  class Redfish
    # Initialise this transport with a set of credentials
    def initialize(context, connection_info)

      hostname = connection_info[:hostname]
      username = connection_info[:username]
      password = connection_info[:password]
      prefix = '/redfish/v1'

      client = RedfishClient.new(hostname,
        prefix: prefix,
        verify: false
      )

      client.login(username, password.unwrap)

      @connection_info = connection_info
      @system = client.Systems.Members[0]
      @systempath = client.Systems.Members[0].raw['@odata.id']
      @manager = client.Managers.Members[0]
      @managerpath = client.Managers.Members[0].raw['@odata.id']
      @client = client
    end

    # Verifies that the stored credentials are valid, and that we can talk to the target
    def verify(context)
      # context.debug("Checking connection to #{@connection_info[:host]}:#{@connection_info[:port]}")
      # in a real world implementation, the password would be checked by connecting
      # to the target device or checking that an existing connection is still alive
      raise 'authentication error' if @connection_info[:password].unwrap == 'invalid'
    end

    # Retrieve facts from the target and return in a hash
    def facts(context)

      oem_model = @system.raw['Model']
      oem_vendor = @client['Oem'].raw.keys[0]
      health_status = @system.raw['Status']['Health']
      redfish_version = @client['RedfishVersion']
      power_state = self.get_powerstate
      attributes = self.get_bios_attributes
      firmware = self.get_firmware_version

      context.debug('Retrieving facts')
      {
        'operatingsystem'         => 'redfish',
        'oemmodel'                => oem_model.to_s,
        'oemvendor'               => oem_vendor.to_s,
        'healthstatus'            => health_status.to_s,
        'redfishversion'          => redfish_version.to_s,
        'powerstate'              => power_state.to_s,
        'biosattributes'          => attributes,
        'firmwareversion'         => firmware.to_s,
      }
    end

    # Close the connection and release all resources
    def close(context)
      context.debug('Logout connection')
      @connection_info = nil
      @client.logout
      @client = nil
      @system = nil
    end

    def camelize( string )
      string.split('_').collect(&:capitalize).join
    end

    def normalize( string )
      string.split(/(?=[A-Z])/).join('_').downcase    
    end

    def get_bios_attributes
      attributes = @system.Bios['Attributes'].raw
      attributes
    end

    def set_bios_attributes(options)
      @system.request('patch', '@data.id', "#{@systempath}/Bios/Settings", { "Attributes" => options })

      @manager.Links.Oem.Dell.Jobs.post(
        :payload => {"TargetSettingsURI":"#{@systempath}/Bios/Settings"}
      )
    end

    def set_bios_attribute(args)
      payload = {"#{args[:name]}" => "#{args[:value]}"}
      Puppet.debug("Payload is #{payload}")
      response = @system.request('patch', '@data.id', "#{@systempath}/Bios/Settings", { "Attributes" => payload })
      unless [200, 202, 204].include?(response.status)
        raise "Bios failed: #{response.body}."
      end
    end

    def set_bios_job
      oem_vendor = @client['Oem'].raw.keys[0]
      response = @manager.Links.Oem[oem_vendor].Jobs.post(
        :payload => {"TargetSettingsURI":"#{@systempath}/Bios/Settings"}
      )
      unless [200, 202, 204].include?(response.status)
        raise "Bios job failed: #{response.body}."
      end
      response
    end

    def set_apply_reboot
      self.set_bios_job
      self.set_powerstate("ForceRestart")
    end

    def get_powerstate
      state = @system['PowerState']
      state
    end

    def set_powerstate(rtype)
      Puppet.debug("New state #{rtype}")
      response = @system.Actions["#ComputerSystem.Reset"].post(
        :field => "target", :payload => { "ResetType" => rtype.to_s }
      )
      unless [200, 202, 204].include?(response.status)
        raise "'#{state}' reset failed: #{response.body}."
      end
    end

    def get_firmware_version
      version = nil
      inventories = @client.UpdateService.FirmwareInventory.Members

      inventories.each do |inventory|
        if inventory['Name'] = "Integrated Dell Remote Access Controller"
          version = inventory['Version']
        end
      end
      
      version
    end

    def set_firmware_version(url)
      Puppet.debug("New firmware #{url}")
      response = @client.UpdateService.Actions["#UpdateService.SimpleUpdate"].post(
        :payload => { "ImageURI" => url.to_s }
      )
      unless [200, 202, 204].include?(response.status)
        raise "'#{url}' reset failed: #{response.body}."
      end
    end

  end
end
