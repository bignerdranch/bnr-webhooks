require 'json'

module Bnr
  module Webhooks
    class Receiver
      include Bnr::Webhooks::Signing

      attr_reader :event, :source, :signature, :api_key, :worker, :dispatcher

      def self.process(source, headers)
        new(source, headers).process
      end

      def initialize(source,
                     headers,
                     api_key: Bnr::Webhooks.api_key,
                     worker:,
                     dispatcher: Bnr::Webhooks::Dispatcher.new)
        @source = source
        @api_key = api_key
        @worker = worker
        @dispatcher = dispatcher

        @event     = headers.fetch(Bnr::Webhooks::EVENT_HEADER)
        @signature = headers.fetch(Bnr::Webhooks::SIGNATURE_HEADER)
      end

      def process(async: true)
        return unless valid?

        if async
          process_async
        else
          process_now
        end
      end

      def valid?
        properly_signed?
      end

      private

      def handler
        dispatcher.for(event)
      end

      def process_async
        worker.call(handler, event, parsed_source)
      end

      def process_now
        handler.call(event, parsed_source)
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
