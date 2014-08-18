module Spree
  class OmnikassaController < Spree::StoreController
    # Omnikassa does a post without knowing our authenticity token
    skip_before_filter :verify_authenticity_token

    around_filter :in_transaction, only: :success

    before_filter :valid_seal, except: [:start, :error, :restart]
    before_filter :load_payment, only: [:start, :success]
    before_filter :load_processor, only: [:start]
    before_filter :load_omnikassa_payment, only: :start
    before_filter :load_order, only: :success

    def restart
      order = Spree::Order.find params[:order_id]
      authorize! :read, order, params[:token]

      # This will create a new payment. Maybe it would be easier to copy the
      # previous omnikassa payment
      payment = order.payments.create(amount: order.outstanding_balance)
      payment.payment_method = Spree::BillingIntegration::Omnikassa.first
      payment.save!

      redirect_to omnikassa_start_url(payment.id)
    end

    def start
      @payment.pend!

      @data = @processor.data_string
      @seal = @processor.seal @data
      @url = Spree::Config[:omnikassa_url]
    end

    def success
      omnikassa_data = parse_data_string params[:Data]

      @payment.omnikassa_payments.create! \
        omnikassa_amount: omnikassa_data[:amount],
        omnikassa_capture_day: omnikassa_data[:captureDay],
        omnikassa_capture_mode: omnikassa_data[:captureMode],
        omnikassa_currency_code: omnikassa_data[:currencyCode],
        omnikassa_merchant_id: omnikassa_data[:merchantId],
        omnikassa_order_id: omnikassa_data[:orderId],
        omnikassa_transaction_date_time: omnikassa_data[:transactionDateTime],
        omnikassa_transaction_reference: omnikassa_data[:transactionReference],
        omnikassa_authorisation_id: omnikassa_data[:authorisationId],
        omnikassa_key_version: omnikassa_data[:keyVersion],
        omnikassa_payment_mean_brand: omnikassa_data[:paymentMeanBrand],
        omnikassa_payment_mean_type: omnikassa_data[:paymentMeanType],
        omnikassa_response_code: omnikassa_data[:responseCode]

      redirect_to case omnikassa_data[:responseCode]
        when '00' # Payment is completed
          @payment.send("complete!") if payment.state != 'completed'
          flash[:success] = t(:payment_success)
          order_url(@order, { token: order.token })

        when '60' # Payment is pending (omni received this state from the bank)
          @payment.pend! if payment.state != 'pending'
          flash[:error] = t(:payment_pending)
          omnikassa_pending_url(@payment.id, token: @order.token)

        else # All other states are failures
          @payment.send("failure!") if payment.state != 'failed'
          flash[:error] = t(:payment_failed)
          omnikassa_error_url(@payment.id, token: @order.token)
        end
    end

    def error
      @order = order
    end

    private

    def in_transaction
      ActiveRecord::Base.transaction do
        yield
      end
    end

    def parse_data_string(data_string)
      query_string = data_string.gsub('|','&')
      hashed_query_string = Rack::Utils.parse_nested_query(query_string)
      hashed_query_string.deep_symbolize_keys
    end

    def load_payment
      @payment = payment
    end

    def load_omnikassa_payment
      @omnikassa_payment = @payment.omnikassa_payments.last # TODO: Not thread safe
    end

    def load_order
      @order = @payment.order
    end

    def load_processor
      @processor = Spree::OmnikassaPayment.processor(@payment)
    end

    def order
      payment.order
    end

    def payment
      payment = Spree::Payment.find params[:payment_id]
      authorize! :read, payment.order, params[:token]
      payment
    end

    def valid_seal
      return if valid_seal?

      flash[:error] = "Invalid seal"
      head :forbidden
    end

    def valid_seal?
      Spree::OmnikassaProcessor.seal(params[:Data]) == params[:Seal]
    end
  end
end
