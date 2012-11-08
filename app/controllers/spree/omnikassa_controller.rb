module Spree
  class OmnikassaController < Spree::BaseController
    ssl_required

    def start
      @order = current_order
    end

    private 
      def signature
        
      end

      def data
        
      end
    
      def payment_data
        {:amount => '',
         :currencyCode => '',
         :merchantId => '',
         :normalReturnUrl => '',
         :automaticReturnUrl => '',
         :transactionReference => '',
         :keyVersion => ''}
      end
  end
end
