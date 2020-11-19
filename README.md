# redfish

The README template below provides a starting point with details about what information to include in your README.

## Description

This module supports Dell & HP implementations of Redfish. The Redfish standard is a suite of specifications that deliver an industry standard protocol providing a RESTful interface for the management of servers, storage, networking, and converged infrastructure.

https://en.wikipedia.org/wiki/Redfish_(specification)

## Setup

### Requirements

* Enable *pluginsync*
* Hostname or IP Address for Out-of-Band Controller (iDRAC/iLO)
* Install *device_manager* module 
    * `puppet module install puppetlabs-device_manager`
* Install *redfish_client* Ruby Gem
    * https://rubygems.org/gems/redfish_client

### Installation

* The goal is to publish this to Puppet Forge as an official Dell module. Until that time you can manually install the module for testing.
* Manual installation:
```
mkdir /etc/puppetlabs/code/environments/production/modules/redfish
unzip redfish-module-master.zip
cd redfish-module-master
rsync -av . /etc/puppetlabs/code/environments/production/modules/redfish/
```

## Getting Started

#### Agentless

To get started with agentless setup, the module must be installed in your puppet enterprise enviroment
1. From Puppet Enterprise Web UI, go to Setup >> Inventory
2. Select network devices and select redfish as the device type
3. It will ask for: 
    a. host (example of host is https://IP.ADDRE.SS )
    b. user
    c. password
4. Find your node under Inspect >> Nodes and click run puppet
5. You can now inspect the facts
6. You can add a classification for this remote node on your site.pp or using profiles and roles as you wish.

#### Proxy Agent **OPTIONAL**

You can also choose to run the values from a proxy agent. This means another existing node can control your host. To get started, look for the manifests/ini.pp for this module for an example:

1. Copy and modify the code below and classify a node with that information. The details can be hardcoded under site.pp or the information can come from hiera.

**Example 1: site.pp**
```
device_manager { 
    'node01-idrac':
        type        => 'redfish',
        credentials => {
          host     => 'https://192.168.1.100',
          username => 'admin',
          password => 'password',
        },
}
```
**Example 2: /etc/puppetlabs/code/environments/production/data/nodes/proxyhost.example.com.yaml**
```
device_manager::devices:
    node01-idrac:
        type: 'redfish'
        credentials:
            hostname: 'https://192.168.1.100'
            username: 'root'
            password: 'calvin'
    node02-idrac:
        type: 'redfish'
        credentials:
            hostname: 'https://node02-idrac.example.com'
            username: 'root'
            password: 'calvin'
```
2. Proxy Requirements
    a. You will need the device manager module to make use of the device manager. https://forge.puppet.com/puppetlabs/device_manager
```puppet module install puppetlabs-device_manager```
    b. You will need to install the *redfish_client* Ruby Gem. https://rubygems.org/gems/redfish_client
```
node 'proxynode.example.com'  {
    include device_manager::devices
    package { 'redfish_client' :
        provider => 'puppet_gem',
        ensure   => installed,
    }
}
```
3. A requirement of the device manager module is to have a system user called pe-user.  ``` useradd pe-user```
4. Once the file has been created, you can run puppet from your proxy agent using cronjobs or from Puppet Enterprise as tasks. Refer to https://forge.puppet.com/puppetlabs/device_manager#orchestration
5. You can now apply any puppet manifests or make use of puppet device to run puppet on the fly for your appropriate remote device.

## Usage

```
# Applies redfish attributes
redfish_attribute { 'AssetTag':
    value => 'dell'
}

redfish_attribute { 'WriteCache':
    value => 'Enabled'
}

# Creates bios config job (Will report error if "No pending data present to create a Configuration job")
redfish_job {
    'current': apply => 'yes' 
}

# Creates bios job and reboots 
redfish_reboot {'current'
    reboot => true
}

# Sets power state
redfish_power {'current'
    state => 'on' # Enum[on, force_off, force_restart, graceful_shutdown, nmi]
}

# Upgrades firmware
redfish_firmware {'current'
    url => 'http://server.example.com/FIRMWARE.EXE'
}
```

**Example Manifest**
```
node 'node01-idrac','node02-idrac' {
    # Set Attributes
    redfish_attribute { 'AssetTag': value => 'Dell0001' }
    redfish_attribute { 'BootMode': value => 'Bios' }
    redfish_attribute { 'AcPwrRcvry': value => 'On' }
    redfish_attribute { 'AcPwrRcvryDelay': value => 'Random' }

    # Creates BIOS Config Job (Submitting a Configuration Job is a requirement on Dell Servers)
    redfish_job {'current': apply => 'yes' }

    # Reboot Server
    redfish_power {'current': state => 'force_restart' } 
}
```

## Using Devices
```
# Run against all devices (This will generate certificate requests)
puppet device -v
# Run against target device
puppet device --target node01-idrac -v
# Get specific resource attribute
puppet device --target node01-idrac -v --resource redfish_attribute AssetTag
```

## Limitations

At the moment, only vendors supported are Dell & HP. 

## Development

Feel free to contribute your own vendor or enhancements.

## Release Notes/Contributors/Etc. **Optional**

The basis for this work was the excellent library redfish_client