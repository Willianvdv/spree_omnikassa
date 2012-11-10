module Spree
  class OmnikassaController < Spree::BaseController
    ssl_required
    skip_before_filter :verify_authenticity_token
    before_filter :valid_token
    before_filter :valid_seal, :except => :start

    def start
      # Start an omnikassa transaction
      @data = omnikassa.data
      @seal = omnikassa.seal @data
    end

    def success
      data = omnikassa.parse_data_string params[:Data] 

      # Validate
      # Check amount
      unless data[:amount] == omnikassa.amount.to_s
        head :forbidden
      end
      # Check currencyCode
      unless data[:currencyCode] == omnikassa.currency_code
        head :forbidden
      end
      # Check merchantId
      unless data[:merchantId] == omnikassa.merchant_id
        head :forbidden
      end

      # Create omnikassa payment object
      Spree::OmnikassaPayment.create({
        :omnikassa_amount => data[:amount],
        :omnikassa_capture_day => data[:captureDay],
        :omnikassa_capture_mode => data[:captureMode], 
        :omnikassa_currency_code => data[:currencyCode],
        :omnikassa_merchant_id => data[:merchantId],
        :omnikassa_order_id  => data[:orderId],
        :omnikassa_transaction_date_time => data[:transactionDateTime],
        :omnikassa_transaction_reference => data[:transactionReference],
        :omnikassa_authorisation_id => data[:authorisationId],
        :omnikassa_key_version => data[:keyVersion],
        :omnikassa_payment_mean_brand => data[:paymentMeanBrand],
        :omnikassa_payment_mean_type => data[:paymentMeanType],
        :omnikassa_response_code => data[:responseCode],
      })

      redirect_to order_url(order) 
    end

    def success_automatic
      # Automatic success response
    end

    def error
      # Error
    end
    
    private
      def valid_seal
        unless has_valid_seal?
          flash[:error] = "Invalid seal"
          head :forbidden
        end
      end

      def has_valid_seal?
        omnikassa.seal(params[:Data]) == params[:Seal]
      end

      def valid_token
        unless has_valid_token?
          flash[:error] = "Invalid token"
          head :forbidden 
        end
      end

      def has_valid_token?
        params[:token] == omnikassa.payment_token
      end

      def omnikassa  
        domain = "#{request.protocol}#{request.host_with_port}" 
        Spree::Omnikassa.new payment, domain
      end

      def payment
        Spree::Payment.find(params[:payment_id])
      end

      def order
        payment.order
      end
  end
end

#{"Data"=>"amount=17009|captureDay=0|captureMode=AUTHOR_CAPTURE|currencyCode=978|merchantId=002020000000001|orderId=null|transactionDateTime=2012-11-10T14:04:33+01:00|transactionReference=PREFIX1069267069194|keyVersion=1|authorisationId=0020000006791167|paymentMeanBrand=IDEAL|paymentMeanType=CREDIT_TRANSFER|responseCode=00",
#   "InterfaceVersion"=>"HP_1.0",
#    "Encode"=>"",
#     "Seal"=>"d6c09e482d2a62a3daef755d26ce0058b1b826cb8ee42b0e133a965d6fafb8c1",
#      "payment_id"=>"194",
#       "token"=>"45475a9001"}
