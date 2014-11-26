module Bnr
  module Webhooks
    class Subscriber
      attr_reader :api_key, :url

      def initialize(api_key:, url:)
        @api_key = api_key
        @url = url
      end
    end
  end
end
