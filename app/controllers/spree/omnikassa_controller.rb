module Spree
  class OmnikassaController < Spree::BaseController
    #ssl_required
    #skip_before_filter :verify_authenticity_token
    #before_filter :valid_token
    #before_filter :valid_seal, :except => [:start, :error]

    def start
      # Start an omnikassa transaction
      payment.send('started_processing!')
      @data = data_string
      @seal = seal @data
      #@url = Spree::Config[:omnikassa_url]
    end

    # def success
    #   ActiveRecord::Base.transaction do
    #     data = omnikassa.parse_data_string params[:Data]

    #     # Validate
    #     unless data[:amount] == omnikassa.amount.to_s
    #       head :forbidden
    #     end

    #     unless data[:currencyCode] == omnikassa.currency_code
    #       head :forbidden
    #     end

    #     unless data[:merchantId] == omnikassa.merchant_id
    #       head :forbidden
    #     end

    #     # Create omnikassa payment object
    #     Spree::OmnikassaPayment.create({
    #       :payment => payment,
    #       :omnikassa_amount => data[:amount],
    #       :omnikassa_capture_day => data[:captureDay],
    #       :omnikassa_capture_mode => data[:captureMode],
    #       :omnikassa_currency_code => data[:currencyCode],
    #       :omnikassa_merchant_id => data[:merchantId],
    #       :omnikassa_order_id  => data[:orderId],
    #       :omnikassa_transaction_date_time => data[:transactionDateTime],
    #       :omnikassa_transaction_reference => data[:transactionReference],
    #       :omnikassa_authorisation_id => data[:authorisationId],
    #       :omnikassa_key_version => data[:keyVersion],
    #       :omnikassa_payment_mean_brand => data[:paymentMeanBrand],
    #       :omnikassa_payment_mean_type => data[:paymentMeanType],
    #       :omnikassa_response_code => data[:responseCode],
    #     })

    #     response_code = data[:responseCode]

    #     if response_code == '00'
    #       payment.send("complete!")
    #       # TODO: Find a way to call the original update method on the CheckoutController
    #       order.next
    #       flash[:success] = t(:payment_success)
    #       redirect_to order_url(order)
    #     elsif response_code == '60'
    #       payment.send("pend!")
    #       order.next
    #       flash[:error] = t(:payment_pending)
    #       redirect_to order_url(order)
    #     else
    #       payment.send("failure!")
    #       flash[:error] = t(:payment_failed)
    #       redirect_to :omnikassa_error
    #     end
    #   end
    # end

    # def success_automatic
    #   # Automatic success response
    #   if payment.state == 'processing'
    #     success
    #   end
    # end

    # def error
    #   # Error
    # end

    private

      #SHRD
      def uri
        "#{request.protocol}#{request.host_with_port}"
      end

      def money
        # TODO: Check if this is the right way to get the currency
        ::Money.parse([payment.amount, Spree::Config[:currency]].join)
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

      def payment_token
        token payment.id
      end

      def token s
        # TODO: replace with a more secure implementation
        a = "#{s}#{Rails.application.config.secret_token[0,10]}"
        (Digest::SHA256.new << a).to_s()[0,10]
      end

      def order
        payment.order
      end

      def secret
        Spree::Config[:omnikassa_secret_key]
      end

      def seal d
        (Digest::SHA256.new << "#{d}#{secret}").to_s
      end

      # REQ
      def data_string
        payment_data.map{|k,v| "#{k}=#{v}"}.join('|')
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

      def normal_return_url
        "#{uri}/omnikassa/success/#{payment.id}/#{payment_token}/"
      end

      def automatic_response_url
        "#{uri}/omnikassa/success/automatic/#{payment.id}/#{payment_token}/"
      end

      def transaction_reference_prefix
        Spree::Config[:omnikassa_transaction_reference_prefix]
      end

      def transaction_reference
        "#{transaction_reference_prefix}#{order.id}#{payment.id}"
      end

      def key_version
        Spree::Config[:omnikassa_key_version]
      end



      # def amount
      #   money.cents()
      # end

      # def currency_code
      #   money.currency.iso_numeric
      # end

      # def merchant_id
      #   Spree::Config[:omnikassa_merchant_id]
      # end

      # def key_version
      #   Spree::Config[:omnikassa_key_version]
      # end

      # def secret
      #   Spree::Config[:omnikassa_secret_key]
      # end

      # def seal d
      #    (Digest::SHA256.new << "#{d}#{secret}").to_s
      # end



      # def uri
      #   "#{request.protocol}#{request.host_with_port}"
      # end

      # def normal_return_url
      #   "#{uri}/omnikassa/success/#{@payment.id}/#{payment_token}/"
      # end

      # def automatic_response_url
      #   "#{uri}/omnikassa/success/automatic/#{@payment.id}/#{payment_token}/"
      # end

      # def payment_id
      #   @payment.id
      # end

      # def payment_token
      #   self.class.token payment_id
      # end

      # def transaction_reference_prefix
      #    Spree::Config[:omnikassa_transaction_reference_prefix]
      # end

      # def transaction_reference
      #   "#{transaction_reference_prefix}#{@order.id}#{payment_id}"
      # end

      # def payment_data
      #   {:amount => amount,
      #    :currencyCode => currency_code,
      #    :merchantId => merchant_id,
      #    :normalReturnUrl => normal_return_url,
      #    :automaticResponseUrl => automatic_response_url,
      #    :transactionReference => transaction_reference,
      #    :keyVersion => key_version,}
      # end

      # def parse_data_string data_string
      #    Rack::Utils.parse_nested_query(data_string.gsub('|','&')).deep_symbolize_keys
      # end

      # def response data_string
      #   data = parse_data_string
      # end

      # def self.token s
      #   # TODO: replace with a more secure implementation
      #   a = "#{s}#{Rails.application.config.secret_token[0,10]}"
      #   (Digest::SHA256.new << a).to_s()[0,10]
      # end

      # def valid_seal
      #   unless has_valid_seal?
      #     flash[:error] = "Invalid seal"
      #     head :forbidden
      #   end
      # end

      # def has_valid_seal?
      #   omnikassa.seal(params[:Data]) == params[:Seal]
      # end



      # def omnikassa
      #   uri = "#{request.protocol}#{request.host_with_port}"
      #   Spree::Omnikassa.new payment, uri
      # end

      def payment
        Spree::Payment.find(params[:payment_id])
      end

      # FLTRS
      def valid_token
        unless has_valid_token?
          flash[:error] = "Invalid token"
          head :forbidden
        end
      end

      def has_valid_token?
        params[:token] == omnikassa.payment_token
      end

      def valid_seal
        unless has_valid_seal?
          flash[:error] = "Invalid seal"
          head :forbidden
        end
      end

      def has_valid_seal?
        omnikassa.seal(params[:Data]) == params[:Seal]
      end
  end
end
