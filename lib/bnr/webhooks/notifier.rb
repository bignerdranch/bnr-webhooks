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
        http_client.post do |request|
          request.url subscriber.url
          request.headers['Content-Type'] = 'application/json'
          request.headers[Bnr::Webhooks::EVENT_HEADER] = event
          request.headers[Bnr::Webhooks::SIGNATURE_HEADER] = signature
          request.body = body
        end
      end

      private

      def body
        source.to_json
      end

      def signature
        sign(subscriber.api_key, body)
      end
    end
  end
end
