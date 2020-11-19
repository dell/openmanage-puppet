# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/redfish_reboot'

RSpec.describe 'the redfish_reboot type' do
  it 'loads' do
    expect(Puppet::Type.type(:redfish_reboot)).not_to be_nil
  end
end
