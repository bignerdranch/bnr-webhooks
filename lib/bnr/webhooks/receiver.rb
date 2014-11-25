require 'json'
require 'openssl'

module Bnr
  module Webhooks
    class Receiver
      HMAC_DIGEST = OpenSSL::Digest.new('sha1')

      attr_reader :event, :source, :signature, :api_key, :worker, :event_handler

      def self.process(source, headers)
        new(source, headers).process
      end

      def initialize(source,
                     headers,
                     api_key: Bnr::Webhooks.api_key,
                     worker:,
                     event_directory:)
        @source = source
        @api_key = api_key
        @worker = worker
        @event  = headers.fetch('X-BNR-Webhook-Event-Name')
        @signature = headers.fetch('X-BNR-Webhook-Signature')
        @event_handler = event_directory.fetch(event)
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

      def process_async
        worker.process(event_handler, event, parsed_source)
      end

      def process_now
        event_handler.call(event, parsed_source)
      end

      def parsed_source
        @parsed_source ||= JSON.parse(source)
      end

      def expected_signature
        'sha1='+OpenSSL::HMAC.hexdigest(HMAC_DIGEST, api_key, source)
      end

      def properly_signed?
        signature == expected_signature
      end
    end
  end
end
