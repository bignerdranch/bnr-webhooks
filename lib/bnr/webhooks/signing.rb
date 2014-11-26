require 'openssl'

module Bnr
  module Webhooks
    module Signing
      extend self

      HMAC_DIGEST = OpenSSL::Digest.new('sha1')

      def sign(key, source)
        'sha1='+OpenSSL::HMAC.hexdigest(HMAC_DIGEST, key, source)
      end
    end
  end
end
