require 'money'

module Spree
  class OmnikassaPayment
    def initialize(order)
      @order = order
    end

    def money
      ::Money.parse([@order.amount, Spree::Config[:currency]].join)
    end

    def amount
      money.cents() 
    end

    def currencyCode
      money.currency.iso_numeric
    end

    def merchantId
      Spree::Config[:omnikassa_merchant_id]
    end

    def keyVersion
      Spree::Config[:omnikassa_key_version]
    end
    
    def payment_data
      {:amount => amount,
       :currencyCode => currencyCode,
       :merchantId => merchantId,
       :normalReturnUrl => '',
       :automaticReturnUrl => '',
       :transactionReference => '',
       :keyVersion => keyVersion,
      }
    end 
  end
end
