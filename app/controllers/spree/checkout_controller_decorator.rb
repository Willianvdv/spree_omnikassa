Spree::CheckoutController.class_eval do
  private

  def completion_route
    if is_omnikassa_payment?
      url_for :controller => 'omnikassa',
              :action => 'start',
              :payment_id => payment.id,
              :token => @order.token
    else
      # This is the original completion route
      spree.order_path(@order)
    end
  end

  def payment
    @order.payments.first
  end

  def is_omnikassa_payment?
    payment_method = @order.payments.order(:id).last.payment_method
    payment_method.class == Spree::BillingIntegration::Omnikassa
  end
end
