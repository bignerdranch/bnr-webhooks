require 'json'

module Bnr
  module Webhooks
    class Receiver
      include Bnr::Webhooks::Signing

      DEFAULT_WORKER = if defined?(::Sidekiq)
                         Bnr::Webhooks::SidekiqWorker
                       else
                         Bnr::Webhooks::Worker
                       end

      attr_reader :event, :source, :signature, :api_key, :worker, :dispatcher

      def self.process(source, headers)
        new(source, headers).process
      end

      def initialize(source,
                     headers,
                     api_key: Bnr::Webhooks.api_key,
                     worker: DEFAULT_WORKER,
                     dispatcher: Bnr::Webhooks::Dispatcher.new)
        @source = source
        @api_key = api_key
        @worker = worker
        @dispatcher = dispatcher

        @event     = headers.fetch(Bnr::Webhooks::EVENT_HEADER)
        @signature = headers.fetch(Bnr::Webhooks::SIGNATURE_HEADER)
      end

      def process
        return unless valid?

        worker.call(handler, event, parsed_source)
      end

      def valid?
        properly_signed?
      end

      private

      def handler
        dispatcher.for(event)
      end

      def parsed_source
        @parsed_source ||= JSON.parse(source)
      end

      def expected_signature
        sign(api_key, source)
      end

      def properly_signed?
        signature == expected_signature
      end
    end
  end
end
