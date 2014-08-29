require 'spec_helper'

describe "Checkout", js: true do
  let!(:omnikassa_payment_method) { create(:omnikassa_payment_method, environment: 'test') }

  before do
    Spree::Store.current.url = '127.0.0.1:54979'
    Spree::Store.current.save!(validate: false)

    reset_spree_preferences do |config|
      config.currency = "EUR"
      config.omnikassa_url = 'https://payment-webinit.simu.omnikassa.rabobank.nl/paymentServlet'
      config.omnikassa_merchant_id = '002020000000001'
      config.omnikassa_secret_key = '002020000000001_KEY1'
      config.omnikassa_key_version = '1'
      random_prefix = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
      config.omnikassa_transaction_reference_prefix = "SPROMNI#{random_prefix}"
    end
  end

  describe 'pay with omnikassa' do
    let!(:order) { OrderWalkthrough.up_to(:delivery) }

    before :each do
      user = create(:user)
      order.user = user
      order.update!

      order.stub(:available_payment_methods => [ omnikassa_payment_method ])

      Spree::CheckoutController.any_instance.stub(:current_order => order)
      Spree::CheckoutController.any_instance.stub(:try_spree_current_user => user)
    end

    it 'redirects to omnikassa', actual_ideal_payment: true do
      goto_omnikassa
      expect(current_path).to match 'payment/selectpaymentmethod'
    end

    it 'success after omnikassa', actual_ideal_payment: true do
      goto_omnikassa
      do_omnikassa_ideal_payment
      expect(current_path).to eq('/success/1/')
    end
  end
end

def goto_omnikassa
  visit spree.checkout_state_path(:payment)

  choose('Omnikassa')
  click_button "Save and Continue"
  click_button "Place"
  sleep 3 if Capybara.javascript_driver != :selenium # Wait for redirect
end

def do_omnikassa_ideal_payment
  first('.paymentmeanbutton:nth-child(2) > a').click

  page.find('.confirm').click
  page.find('.bouton_submit').click
  page.find('.finalize').click

  sleep 3 if Capybara.javascript_driver != :selenium  # Wait for redirect

  if Capybara.javascript_driver == :selenium
    # Accept SSL warning
    a = page.driver.browser.switch_to.alert
    a.accept
  end
end
