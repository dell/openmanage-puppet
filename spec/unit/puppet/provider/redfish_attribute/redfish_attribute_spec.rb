# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::RedfishAttribute')
require 'puppet/provider/redfish_attribute/redfish_attribute'

RSpec.describe Puppet::Provider::RedfishAttribute::RedfishAttribute do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }

  describe '#get' do
    it 'processes resources' do
      expect(context).to receive(:debug).with('Returning pre-canned example data')
      expect(provider.get(context)).to eq [
        {
          name: 'foo',
          ensure: 'present',
        },
        {
          name: 'bar',
          ensure: 'present',
        },
      ]
    end
  end

  describe 'update(context, name, should)' do
    it 'updates the resource' do
      expect(context).to receive(:notice).with(%r{\AUpdating 'foo'})

      provider.update(context, 'foo', name: 'foo', ensure: 'present')
    end
  end

end
