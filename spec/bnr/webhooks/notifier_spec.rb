require 'spec_helper'
require 'faraday'

describe Bnr::Webhooks::Notifier do
  let(:source) { { "id" => "15" } }
  let(:source_json) { source.to_json }
  let(:event) { 'widget.destroy' }
  let(:url) { "https://bignerdranch.com/webhooks" }
  let(:subscriber) { double("Subscriber", api_key: api_key, url: url) }
  let(:api_key) { 'test_key' }
  let(:signature) { Bnr::Webhooks::Signing.sign(api_key, source_json) }
  let(:headers) {
    {
      'X-BNR-Webhook-Event-Name' => event,
      'X-BNR-Webhook-Signature' => signature
    }
  }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:http_client) {
    Faraday.new do |builder|
      builder.adapter :test, stubs do |stub|
        stub.post(url, nil, headers) { [204, {}, nil] }
      end
    end
  }
  subject(:notifier) { described_class.new(event, source, subscriber, http_client: http_client) }

  describe '#notify' do
    subject(:response) { notifier.notify }

    after do
      stubs.verify_stubbed_calls
    end

    it { should be_success }

    context 'when debug endpoint is provided' do
      let(:debug_endpoint) { 'https://bignerdranch.com/webhooks/monitor' }
      let(:debug_headers) { headers.merge(
        'X-BNR-Webhook-Original-Destination' => url
      ) }
      let(:stubs) {
        Faraday::Adapter::Test::Stubs.new do |stub|
          stub.post(debug_endpoint, nil, debug_headers) { |env| [200, {}, nil] }
        end
      }

      before do
        Bnr::Webhooks.configure do |config|
          config.debug_endpoint = debug_endpoint
        end
      end

      it { should be_success }

      after do
        Bnr::Webhooks.defaults!
      end
    end
  end
end
