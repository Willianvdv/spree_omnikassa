module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class Omnikassa < Gateway
      def service_url
        "https://www.moneybookers.com/app/payment.pl"
      end
    end
  end
end


