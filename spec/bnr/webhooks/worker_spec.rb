require 'spec_helper'

describe Bnr::Webhooks::Worker do
  let(:handler) { double('WidgetRemoval')}
  let(:event) { 'widget.destroy' }
  let(:source) { { "id" => "15" } }

  describe '#call' do
    it 'delegates to Worker#perform' do
      expect_any_instance_of(described_class)
        .to receive(:perform)
        .with(handler, event, source)

      described_class.call(handler, event, source)
    end
  end

  describe '.perform' do
    let(:worker) { described_class.new }
    subject { handler }

    after do
      worker.perform(handler, event, source)
    end

    it { should receive(:call).with(event, source) }
  end
end
