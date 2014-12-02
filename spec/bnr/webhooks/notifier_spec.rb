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
  let(:http_client) {
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post(url, nil, headers) { [204, {}, nil] }
      end
    end
  }
  subject(:notifier) { described_class.new(event, source, subscriber, http_client: http_client) }

  describe '#notify' do
    subject(:response) { notifier.notify }
    it { should be_success }
  end
end
