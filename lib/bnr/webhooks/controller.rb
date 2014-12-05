module Bnr
  module Webhooks
    module Controller
      def create
        if Bnr::Webhooks::Receiver.process(request.raw_post,
                                           request.headers,
                                           worker: worker,
                                           dispatcher: dispatcher)
          head status: :no_content
        else
          head status: :unprocessable_entity
        end
      end

      private

      def worker
        Bnr::Webhooks::Worker
      end

      def dispatcher
        Bnr::Webhooks::Dispatcher.new(mapping)
      end

      def mapping
        {}
      end
    end
  end
end
