require 'spec_helper'

describe Bnr::Webhooks::Dispatcher do
  let(:event) { "widget.destroy" }
  let(:widget_removal_factory) { double("WidgetRemovalFactory") }
  let(:mapping) { { event => widget_removal_factory } }
  subject(:dispatcher) { described_class.new(mapping: mapping) }

  describe '#for' do
    subject { dispatcher.for(event) }
    it { should eql(widget_removal_factory) }
  end
end
