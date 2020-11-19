# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/redfish_firmware'

RSpec.describe 'the redfish_firmware type' do
  it 'loads' do
    expect(Puppet::Type.type(:redfish_firmware)).not_to be_nil
  end
end
