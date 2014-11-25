require "active_support/all"
require "bnr/webhooks/version"

module Bnr
  module Webhooks
    extend ActiveSupport::Autoload

    autoload :Receiver

    mattr_accessor :api_key
    @@api_key = 'fake_key'

    class << self
      def configure
        yield self
      end
    end
  end
end
