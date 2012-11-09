require 'money'
require 'digest'

module Spree
  class OmnikassaPayment

    def initialize(order, domain)
      @order = order
      @domain = domain
    end

    def money
      ::Money.parse([@order.amount, Spree::Config[:currency]].join)
    end

    def amount
      money.cents 
    end

    def currency_code
      money.currency.iso_numeric
    end

    def merchant_id
      Spree::Config[:omnikassa_merchant_id]
    end

    def key_version
      Spree::Config[:omnikassa_key_version]
    end
   
    def secret
      Spree::Config[:omnikassa_secret_key]
    end

    def seal
       (Digest::SHA256.new << "#{data}#{secret}").to_s
    end

    def data
      payment_data.map{|k,v| "#{k}=#{v}"}.join('|')
    end

    def normal_return_url
      # Todo: Remove hardcode url
      "#{@domain}/omnikassa/success/"
    end

    def automatic_return_url
      # Todo: Remove hardcode url
      "#{@domain}/omnikassa/success/automatic/"
    end

    def transaction_reference_prefix
       Spree::Config[:omnikassa_transaction_reference_prefix]     
    end

    def transaction_reference
      "#{transaction_reference_prefix}_#{@order.id}"  
    end

    def payment_data
      {:amount => amount,
       :currencyCode => currency_code,
       :merchantId => merchant_id,
       :normalReturnUrl => normal_return_url,
       :automaticReturnUrl => automatic_return_url,
       :transactionReference => transaction_reference,
       :keyVersion => key_version,}
    end 
  end
end
