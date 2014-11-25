module Bnr
  module Webhooks
    class Dispatcher
      attr_reader :mapping

      def initialize(mapping: {})
        @mapping = mapping
      end

      def for(event)
        mapping.fetch(event)
      end
    end
  end
end
