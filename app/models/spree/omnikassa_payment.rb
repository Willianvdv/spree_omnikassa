module Spree
  class OmnikassaProcessor
    def initialize(payment)
      @payment = payment
    end

    def data_string
      payment_data.map{|k,v| "#{k}=#{v}"}.join('|')
    end

    def self.seal string_to_be_sealed
      (Digest::SHA256.new << "#{string_to_be_sealed}#{secret}").to_s
    end

    def seal string_to_be_sealed
      self.class.seal string_to_be_sealed
    end

    private

    def payment_data
      { amount: amount,
        currencyCode: currency_code,
        merchantId: merchant_id,
        normalReturnUrl: normal_return_url,
        automaticResponseUrl: automatic_response_url,
        transactionReference: transaction_reference,
        keyVersion: key_version }
    end

    def money
      Spree::Money.new(@payment.amount).money
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

    def uri
      # TODO: Fix protocol
      "http://#{Spree::Store.current.url}"
    end

    def normal_return_url
      "#{uri}/omnikassa/success/#{@payment.id}/?token=#{@payment.order.guest_token}"
    end

    def automatic_response_url
      "#{uri}/omnikassa/success/automatic/#{@payment.id}/?token=#{@payment.order.guest_token}"
    end

    def transaction_reference_prefix
      Spree::Config[:omnikassa_transaction_reference_prefix]
    end

    def transaction_reference
      "#{transaction_reference_prefix}#{@payment.order.id}#{@payment.id}"
    end

    def key_version
      Spree::Config[:omnikassa_key_version]
    end

    def secret
      self.class.secret
    end

    def self.secret
      Spree::Config[:omnikassa_secret_key]
    end
  end

  class OmnikassaPayment < ActiveRecord::Base
    belongs_to :payment

    def self.processor(payment)
      OmnikassaProcessor.new payment
    end
  end
end
