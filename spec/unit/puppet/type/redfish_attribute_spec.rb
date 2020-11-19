# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/redfish_attribute'

RSpec.describe 'the redfish_attribute type' do
  it 'loads' do
    expect(Puppet::Type.type(:redfish_attribute)).not_to be_nil
  end
end
