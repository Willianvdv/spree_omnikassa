require 'money'
require 'digest'

module Spree
  class Omnikassa
    def initialize(payment, domain)
      @payment = payment
      @order = @payment.order
      @domain = domain
    end

    def money
      # TODO: Check if this is the right way to get the currency
      ::Money.parse([@payment.amount, Spree::Config[:currency]].join)
    end

    def amount
      money.cents() 
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
      # TODO: Remove hardcode url
      "#{@domain}/omnikassa/success/#{@payment.id}/#{payment_token}/"
    end

    def automatic_response_url
      # TODO: Remove hardcode url
      "#{@domain}/omnikassa/success/automatic/#{@payment.id}/#{payment_token}/"
    end

    def transaction_reference_prefix
       Spree::Config[:omnikassa_transaction_reference_prefix]     
    end

    def payment_id
      @payment.id
    end

    def payment_token
      self.class.token payment_id
    end

    def transaction_reference
      "#{transaction_reference_prefix}#{@order.id}#{payment_id}"  
    end

    def payment_data
      {:amount => amount,
       :currencyCode => currency_code,
       :merchantId => merchant_id,
       :normalReturnUrl => normal_return_url,
       :automaticResponseUrl => automatic_response_url,
       :transactionReference => transaction_reference,
       :keyVersion => key_version,}
    end 

    def self.token s
      # TODO: replace with a more secure implementation
      a = "#{s}#{Rails.application.config.secret_token[0,10]}"
      (Digest::SHA256.new << a).to_s()[0,10]    
    end 
  end
end
