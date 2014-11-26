require 'spec_helper'

describe Bnr::Webhooks::Subscriber do
  subject(:subscriber) { described_class.new(subscriber_params) }
  let(:subscriber_params) { { url: 'www.bnr.com', api_key: 'change_me'} }

  describe '#api_key' do
    subject(:api_key) { subscriber.api_key }

    it { is_expected.to eq('change_me') }
  end

  describe '#url' do
    subject(:url) { subscriber.url }

    it { is_expected.to eq('www.bnr.com') }
  end
end
