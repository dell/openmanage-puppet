# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/redfish_job'

RSpec.describe 'the redfish_job type' do
  it 'loads' do
    expect(Puppet::Type.type(:redfish_job)).not_to be_nil
  end
end
