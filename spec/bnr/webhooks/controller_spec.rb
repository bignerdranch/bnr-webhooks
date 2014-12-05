require 'spec_helper'
require 'support/controller_methods'

describe Bnr::Webhooks::Controller do
  let(:controller) {
    Class.new do
      include Bnr::Webhooks::Controller
      include ControllerMethods
    end
  }
  subject(:controller_instance) { controller.new }

  it { should respond_to(:create) }

  describe '#create' do
    subject(:receiver) { Bnr::Webhooks::Receiver }

    after do
      controller_instance.create
    end

    context 'when I do not specify a worker' do
      it { should receive(:process).with("", {}, worker: Bnr::Webhooks::Worker) }
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

      it { should receive(:process).with("", {}, worker: "WebhookWorker") }
    end
  end
end
