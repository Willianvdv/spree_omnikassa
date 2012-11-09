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
      Spree::Config[:omnikassa_transaction_reference_prefix] = 'PREFIX'
      Spree::Config[:omnikassa_key_version] = '7'
    end
    
    subject { Spree::OmnikassaPayment.new(order, 'http://e.x') }

    it 'has a seal' do
      seal = '4418797614984d9c3e2f3ef43a35c46e6aac282d5a4f037cdd39d2886bcbb666'
      subject.seal.should eq seal
    end

    it 'has the data string' do
      d = "amount=1000|currencyCode=978|merchantId=1337|normalReturnUrl=http://e.x/omnikassa/success/|automaticReturnUrl=http://e.x/omnikassa/success/automatic/|transactionReference=PREFIX_#{order.id}|keyVersion=7"
      subject.data.should eq d
    end
    
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

      it 'has the normal return url' do
        subject.payment_data[:normalReturnUrl].should eq 'http://e.x/omnikassa/success/'
      end
 
      it 'has the automatic return url' do
        subject.payment_data[:normalReturnUrl].should eq 'http://e.x/omnikassa/success/'
      end

      it 'has the transaction reference' do
        subject.payment_data[:transactionReference].should eq "PREFIX_#{order.id}"
      end
    end
  end
end
