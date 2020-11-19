# frozen_string_literal: true

require 'spec_helper'
require 'puppet/transport/schema/redfish'

RSpec.describe 'the redfish transport' do
  it 'loads' do
    expect(Puppet::ResourceApi::Transport.list['redfish']).not_to be_nil
  end
end
