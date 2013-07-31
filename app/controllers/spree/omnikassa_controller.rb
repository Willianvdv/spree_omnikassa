module Spree
  class OmnikassaController < Spree::StoreController
    skip_before_filter :verify_authenticity_token
    before_filter :valid_seal, :except => [:start, :error, :restart]

    def restart
      # todo: find out if there a more elegant way to create a payment

      order = Spree::Order.find(params[:order_id])
      authorize! :read, order, params[:token]

      payment = order.payments.create(amount: order.outstanding_balance)
      payment.payment_method = Spree::BillingIntegration::Omnikassa.first
      payment.save!
      redirect_to "/omnikassa/start/#{payment.id}/"
    end

    def start
      # Start an omnikassa transaction
      payment.send('started_processing!')
      @data = data_string
      @seal = seal @data
      @url = Spree::Config[:omnikassa_url]
    end

    def success
      ActiveRecord::Base.transaction do
        data = parse_data_string params[:Data]

        Spree::OmnikassaPayment.create!({
          :payment => payment,
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

        case response_code
          when '00'
            payment.send("complete!") if payment.state != 'completed'
            flash[:success] = t(:payment_success)
            redirect_to order_url(order)
          when '60'
            payment.pend! if payment.state != 'pending'
            flash[:error] = t(:payment_pending)  
            redirect_to "/omnikassa/pending/#{payment.id}/?token=#{order.token}"
          else
            payment.send("failure!") if payment.state != 'failed'
            flash[:error] = t(:payment_failed)
            redirect_to "/omnikassa/error/#{payment.id}/?token=#{order.token}"
        end
      end
    end

    def success_automatic
      success
    end

    def error
      @order = order
    end

    private

      #SHRD
      def uri
        "#{request.protocol}#{request.host_with_port}"
      end

      def money
        Spree::Money.new(payment.amount).money
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
        "#{uri}/omnikassa/success/#{payment.id}/"
      end

      def automatic_response_url
        "#{uri}/omnikassa/success/automatic/#{payment.id}/"
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

      # SCCS
      def parse_data_string data_string
        Rack::Utils.parse_nested_query(data_string.gsub('|','&')).deep_symbolize_keys
      end

      def payment
        pm = Spree::Payment.find(params[:payment_id])
        authorize! :read, pm.order, params[:token]
        pm
      end

      # FLTRS
      def valid_seal
        unless has_valid_seal?
          flash[:error] = "Invalid seal"
          head :forbidden
        end
      end

      def has_valid_seal?
        seal(params[:Data]) == params[:Seal]
      end
  end
end
