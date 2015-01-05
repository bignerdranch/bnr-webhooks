require 'json'
require 'faraday'

module Bnr
  module Webhooks
    class Notifier
      include Bnr::Webhooks::Signing

      attr_reader :event, :source, :subscriber, :http_client

      def self.notify(event:, source:, subscriber:)
        new(event, source, subscriber).notify
      end

      def initialize(event, source, subscriber, http_client: Faraday.new)
        @event = event
        @source = source
        @subscriber = subscriber
        @http_client = http_client
      end

      def notify
        send_to(debug_endpoint) do |request|
          request.headers[Bnr::Webhooks::DESTINATION_HEADER] = subscriber.url
        end if debug_endpoint?

        send_to(subscriber.url)
      end

      private

      def send_to(url)
        http_client.post do |request|
          request.url url
          request.headers['Content-Type'] = 'application/json'
          request.headers[Bnr::Webhooks::EVENT_HEADER] = event
          request.headers[Bnr::Webhooks::SIGNATURE_HEADER] = signature
          request.body = body

          yield(request) if block_given?
        end
      end

      def debug_endpoint
        Bnr::Webhooks.debug_endpoint
      end

      def debug_endpoint?
        debug_endpoint.present?
      end

      def body
        source.to_json
      end

      def signature
        sign(subscriber.api_key, body)
      end
    end
  end
end
