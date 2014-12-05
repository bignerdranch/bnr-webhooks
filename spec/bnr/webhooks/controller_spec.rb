require 'spec_helper'
require 'ostruct'

describe Bnr::Webhooks::Controller do
  let(:controller_methods) {
    Module.new do
      def request
        OpenStruct.new(raw_post: "", headers: {})
      end

      def head(*args)
      end
    end
  }
  let(:controller) {
    controller_methods = self.controller_methods
    Class.new do
      include Bnr::Webhooks::Controller
      include controller_methods
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
        controller_methods = self.controller_methods
        Class.new do
          include Bnr::Webhooks::Controller
          include controller_methods

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
