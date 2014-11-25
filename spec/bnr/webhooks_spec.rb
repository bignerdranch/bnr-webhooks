require 'spec_helper'
require 'bnr/webhooks'

describe Bnr::Webhooks do
  context '#configure' do
    it 'has reasonable defaults' do
      expect(described_class.api_key).to eql('fake_key')
    end

    it 'can override defaults' do
      described_class.configure do |config|
        config.api_key = 'super_secret'
      end

      expect(described_class.api_key).to eql('super_secret')
    end
  end
end
