require 'spec_helper'
require 'spree/core/testing_support/preferences'

module Spree
  describe OmnikassaPayment do
    let(:order) do
      FactoryGirl.create :completed_order_with_totals
    end
    
    before do
      config = Rails.application.config.spree.preferences
      config.reset
      config.currency = "EUR"
      Spree::Config[:omnikassa_merchant_id] = '1337'
      Spree::Config[:omnikassa_key_version] = '7'
    end
    
    subject { Spree::OmnikassaPayment.new(order) }

    context 'payment data' do
      it 'has the amount in cents' do
        subject.payment_data[:amount].should equal 1000
      end

      it 'has has the currency code of the current configuration' do
        subject.payment_data[:currencyCode].should eq '978'
      end

      it 'has the configured key version' do
        subject.payment_data[:keyVersion].should eq '7'
      end

      it 'has the configured merchant id' do
        subject.payment_data[:merchantId].should eq '1337'
      end
    end
  end
end
