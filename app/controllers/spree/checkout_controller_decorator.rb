Spree::CheckoutController.class_eval do
  alias_method :_update, :update

  def update
    # Intercept to do the omnikassa payment before finalizing this order
    if is_state_on_complete? and is_omnikassa_payment?
      # Omnikassa payment candidate, redirect to omnikassa controller
      redirect_to :controller => 'omnikassa', 
                  :action => 'start', 
                  :payment_id => payment.id,
                  :token => token
    else
      # Do original update stuff
      _update
    end
  end

  private

    def token
      Spree::Omnikassa.token payment.id
    end

    def payment
      @order.payments.first
    end

    def is_state_on_complete?
      @order.state == 'confirm'
    end
    
    def is_omnikassa_payment?
      @order.payment_method.class == Spree::BillingIntegration::Omnikassa
    end
end
