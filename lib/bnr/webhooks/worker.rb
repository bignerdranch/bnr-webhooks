module Bnr
  module Webhooks
    class Worker
      def self.call(handler, event, source)
        new.perform(handler, event, source)
      end

      def perform(handler, event, source)
        handler.call(event, source)
      end
    end
  end
end
