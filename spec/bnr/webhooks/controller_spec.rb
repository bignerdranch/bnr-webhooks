require 'spec_helper'
require 'support/controller_methods'

describe Bnr::Webhooks::Controller do
  let(:controller) {
    Class.new do
      include Bnr::Webhooks::Controller
      include ControllerMethods
    end
  }
  let(:default_kwargs) { {
    worker: Bnr::Webhooks::Worker,
    dispatcher: kind_of(Bnr::Webhooks::Dispatcher)
  } }
  subject(:controller_instance) { controller.new }

  it { should respond_to(:create) }

  describe '#create' do
    subject(:receiver) { Bnr::Webhooks::Receiver }

    after do
      controller_instance.create
    end

    context 'when I do not specify a worker' do
      let(:kwargs) { default_kwargs }
      it { should receive(:process).with("", {}, **kwargs) }
    end

    context 'when I specify a worker' do
      let(:controller) {
        Class.new do
          include Bnr::Webhooks::Controller
          include ControllerMethods

          private

          def worker
            "WebhookWorker"
          end
        end
      }
      let(:kwargs) { default_kwargs.merge(worker: "WebhookWorker") }

      it { should receive(:process).with("", {}, **kwargs) }
    end
  end
end
