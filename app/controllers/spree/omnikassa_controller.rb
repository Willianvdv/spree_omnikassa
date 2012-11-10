module Spree
  class OmnikassaController < Spree::BaseController
    ssl_required
    skip_before_filter :verify_authenticity_token
    before_filter :valid_token

    def start
      # Start an omnikassa transaction
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
