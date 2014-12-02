require "active_support/all"
require "bnr/webhooks/version"

module Bnr
  module Webhooks
    extend ActiveSupport::Autoload

    autoload :Dispatcher
    autoload :Notifier
    autoload :Receiver
    autoload :Signing
    autoload :Subscriber
    autoload :Controller

    Error = Class.new(::StandardError)
    DispatcherNotFound = Class.new(Error)

    EVENT_HEADER     = 'X-BNR-Webhook-Event-Name'
    SIGNATURE_HEADER = 'X-BNR-Webhook-Signature'

    mattr_accessor :api_key
    @@api_key = 'fake_key'

    class << self
      def configure
        yield self
      end
    end
  end
end
