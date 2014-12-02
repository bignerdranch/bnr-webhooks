require 'spec_helper'

describe Bnr::Webhooks::Controller do
  let(:controller) {
    class WidgetWebhooksController
      include Bnr::Webhooks::Controller
    end
  }
  subject { controller.new }

  it { should respond_to(:create) }
end
