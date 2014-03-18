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
      #select "United States of America", :from => "#{address}_country_id"
      choose('Omnikassa')
      click_button "Save and Continue"

      sleep 10
    end
  end

end


#order[payments_attributes][][payment_method_id]
