require 'spec_helper'

describe Spree::PaymentMethod::Omnikassa do
  describe 'canceling an order' do
    let!(:order) { create :completed_order_with_totals }
    let!(:omnikassa_payment_method) { create :omnikassa_payment_method }
    let!(:payment) { create :payment,
                            state: 'completed',
                            payment_method: omnikassa_payment_method,
                            order: order}

    it 'allows the order to be canceled' do
      order.cancel!
    end
  end
end
