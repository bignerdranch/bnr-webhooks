module Bnr
  module Webhooks
    class Dispatcher
      attr_reader :mapping

      def initialize(mapping: {})
        @mapping = mapping
      end

      def for(event)
        mapping.fetch(event)
      rescue KeyError
        raise Bnr::Webhooks::DispatcherNotFound,
          "No dispatcher found for \"#{event}\" webhook event"
      end
    end
  end
end
