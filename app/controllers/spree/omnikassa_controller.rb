module Spree
  class OmnikassaController < Spree::BaseController
    ssl_required
    skip_before_filter :verify_authenticity_token

    def start
      # Start an omnikassa transaction
      domain = "#{request.protocol}#{request.host_with_port}" 
      omnikassa = Spree::Omnikassa.new payment, domain
      @seal = omnikassa.seal
      @data = omnikassa.data
    end

    def success
      # Success response
      # TODO: verify payment
      puts ">>>>>>>>>>>>>> #{order.id}"
      redirect_to order_url(order) 
    end

    def success_automatic
      # Automatic success response
    end

    def error
      # Error
    end
    
    private
      def payment
        # TODO: Is this payment of this user?
        Spree::Payment.find(params[:payment_id])
      end

      def order
        payment.order
      end
  end
end
