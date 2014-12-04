module Bnr
  module Webhooks
    class SidekiqWorker < Worker
      include Sidekiq::Worker

      def self.call(handler, event, source)
        perform_async(handler.to_s, event, source)
      end

      def perform(handler_name, event, source)
        handler = handler_name.constantize
        super(handler, event, source)
      end
    end
  end
end
