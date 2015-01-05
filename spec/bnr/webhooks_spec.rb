require 'spec_helper'

describe Bnr::Webhooks do
  context '#configure' do
    it 'has reasonable defaults' do
      expect(described_class.api_key).to eql('fake_key')
      expect(described_class.debug_endpoint).to eql(false)
    end

    it 'can override defaults' do
      described_class.configure do |config|
        config.api_key = 'super_secret'
        config.debug_endpoint = 'http://example.com/monitor'
      end

      expect(described_class.api_key).to eql('super_secret')
      expect(described_class.debug_endpoint).to eql('http://example.com/monitor')
    end
  end
end
