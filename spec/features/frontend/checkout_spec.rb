require 'spec_helper'

describe "Checkout", js: true do
  let!(:country) { create(:country, :states_required => true) }
  let!(:state) { create(:state, :country => country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:mug) { create(:product, :name => "RoR Mug") }
  let!(:payment_method) { create(:check_payment_method) }
  let!(:zone) { create(:zone) }

  let!(:omnikassa_payment_method) { create(:omnikassa_payment_method) }

  before do
    reset_spree_preferences do |config|
      config.currency = "EUR"
      config.omnikassa_url = 'https://payment-webinit.simu.omnikassa.rabobank.nl/paymentServlet'
      config.omnikassa_merchant_id = '002020000000001'
      config.omnikassa_secret_key = '002020000000001_KEY1'
      config.omnikassa_key_version = '1'
      config.omnikassa_transaction_reference_prefix = 'PREFIX'
    end
  end

  describe 'pay with omnikassa' do
    before do
      order = OrderWalkthrough.up_to(:delivery)
      user = create(:user)
      order.user = user
      order.update!

      Spree::CheckoutController.any_instance.stub(:current_order => order)
      Spree::CheckoutController.any_instance.stub(:try_spree_current_user => user)
    end

    it 'redirects to omnikassa' do
      visit spree.checkout_state_path(:payment)
      choose('Omnikassa')
      click_button "Save and Continue"

      sleep 10
    end
  end
end
