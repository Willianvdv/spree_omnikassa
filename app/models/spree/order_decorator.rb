require 'action_controller'

Spree::Order.class_eval do
  state_machine.after_transition :from => :confirm,
                                 :do => :redirect_to_omnikassa_payment

  def redirect_to_omnikassa_payment
    # Redirect to omnikassa payment view
    state = 'omnikassa_payment'
  end
end
