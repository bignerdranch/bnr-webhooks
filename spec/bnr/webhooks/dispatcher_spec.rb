require 'spec_helper'

describe Bnr::Webhooks::Dispatcher do
  let(:widget_removal_factory) { double("WidgetRemovalFactory") }
  let(:mapping) { { "widget.destroy" => widget_removal_factory } }
  subject(:dispatcher) { described_class.new(mapping: mapping) }

  describe '#for' do
    subject { dispatcher.for(event) }

    context "when dispatcher for event exists" do
      let(:event) { "widget.destroy" }
      it { should eql(widget_removal_factory) }
    end

    context "when dispatcher for event does not exist" do
      let(:event) { "widget.obliterate" }
      it { expect { subject }.to raise_error(Bnr::Webhooks::DispatcherNotFound) }
    end
  end
end
