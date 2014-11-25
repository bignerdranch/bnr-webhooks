require 'spec_helper'

describe Bnr::Webhooks::Receiver do
  subject(:request) {
    described_class.new(source_json,
                        headers,
                        api_key: api_key,
                        worker: worker,
                        event_directory: event_directory) }
  let(:source) { { "id" => "15" } }
  let(:source_json) { source.to_json }
  let(:event) { 'widget.destroy' }
  let(:digest) { OpenSSL::Digest.new('sha1') }
  let(:api_key) { 'test_key' }
  let(:worker) { double("WebhookWorker", call: true) }
  let(:signature) {
    'sha1='+OpenSSL::HMAC.hexdigest(digest, api_key, source_json) }
  let(:widget_removal) { double('WidgetRemoval')}
  let(:headers) {
    {
      'X-BNR-Webhook-Event-Name' => event,
      'X-BNR-Webhook-Signature' => signature
    }
  }
  let(:event_directory) {
    {
      "widget.destroy" => widget_removal
    }
  }

  context 'synchronous process' do
    it 'executes the proper event handler' do
      expect(widget_removal).to receive(:call).with(event, source)
      request.process(async: false)
    end
  end

  context 'asynchronous process' do
    it 'queues up a worker' do
      allow(widget_removal).to receive(:call)
      expect(worker).to receive(:call).with(widget_removal, event, source)
      request.process
    end
  end

  context 'valid request' do
    it 'is valid when signature is valid and the event is allowed' do
      expect(request).to be_valid
    end

    describe 'process' do
      it 'returns a truthy value' do
        expect(request.process).to be_truthy
      end
    end
  end

  context 'invalid signature' do
    let(:signature) { 'bad' }

    it 'is not valid when the signature is bad' do
      expect(request).to_not be_valid
    end

    describe 'process' do
      it 'returns a falsey value' do
        expect(request.process).to be_falsy
      end
    end
  end
end
