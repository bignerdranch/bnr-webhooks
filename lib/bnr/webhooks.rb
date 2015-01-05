require "active_support/all"
require "bnr/webhooks/version"

module Bnr
  module Webhooks
    extend ActiveSupport::Autoload

    autoload :Controller
    autoload :Dispatcher
    autoload :Notifier
    autoload :Receiver
    autoload :Signing
    autoload :Subscriber
    autoload :Worker

    Error = Class.new(::StandardError)
    DispatcherNotFound = Class.new(Error)

    EVENT_HEADER       = 'X-BNR-Webhook-Event-Name'
    SIGNATURE_HEADER   = 'X-BNR-Webhook-Signature'
    DESTINATION_HEADER = 'X-BNR-Webhook-Original-Destination'

    mattr_accessor :api_key
    mattr_accessor :debug_endpoint

    class << self
      def configure
        yield self
      end

      def defaults!
        @@api_key = 'fake_key'
        @@debug_endpoint = false
      end
    end

    defaults!
  end
end
