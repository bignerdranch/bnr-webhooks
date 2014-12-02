module Bnr
  module Webhooks
    module Controller
      def create
        if Bnr::Webhooks::Receiver.process(request.raw_post, request.headers)
          head status: :no_content
        else
          head status: :unprocessable_entity
        end
      end
    end
  end
end
