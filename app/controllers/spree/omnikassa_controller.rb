module Spree
  class OmnikassaController < Spree::BaseController
    ssl_required
    skip_before_filter :verify_authenticity_token
    before_filter :valid_token
    before_filter :valid_seal, :except => [:start, :error]

    def start
      # Start an omnikassa transaction
      payment.send('started_processing!')
      @data = omnikassa.data
      @seal = omnikassa.seal @data
    end

    def success
      ActiveRecord::Base.transaction do
        data = omnikassa.parse_data_string params[:Data] 

        # Validate
        unless data[:amount] == omnikassa.amount.to_s
          head :forbidden
        end
      
        unless data[:currencyCode] == omnikassa.currency_code
          head :forbidden
        end
      
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

        response_code = data[:responseCode]
        if response_code == '00'
          payment.send("complete!")
          # TODO: Find a way to call the original update method on the CheckoutController
          order.next
          flash[:success] = t(:payment_success)
          redirect_to order_url(order)
        elsif response_code == '60'
          payment.send("pend!")
          order.next 
          flash[:error] = t(:payment_pending) 
          redirect_to order_url(order)
        else
          payment.send("failure!")
          flash[:error] = t(:payment_failed)
          redirect_to order_url(order)
        end
      end 
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
