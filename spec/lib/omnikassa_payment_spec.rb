require 'spec_helper'
require './lib/spree/omnikassa_payment'

module Spree
  describe OmnikassaPayment do
    let(:order) do
      FactoryGirl.create :order
    end

    subject { Spree::OmnikassaPayment order }

    context 'payment data' do
      it 'has the right amount' do
        puts subject.payment_data
      end
    end
  end
end
