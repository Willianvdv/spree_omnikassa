require 'spec_helper'

module Spree
  describe OmnikassaPayment do
    let(:order) do
      FactoryGirl.create :completed_order_with_totals
    end

    subject { Spree::OmnikassaPayment.new(order) }

    context 'payment data' do
      it 'has the amount in cents' do
        subject.payment_data[:amount].should equal 1000
      end

      it 'has has the currency code of the current configuration' do
        # HARDCODE CURRENCY CODE!!!!
        subject.payment_data[:currencyCode].should eq '840' #840 = $, 978 = €
      end
    end
  end
end
