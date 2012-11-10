require 'spec_helper'
require 'spree/core/testing_support/preferences'

module Spree
  describe Omnikassa do
    let(:payment) do 
      FactoryGirl.create :payment
    end
    
    let(:order) do
      payment.order
    end   
    
    subject { Spree::Omnikassa.new payment, 'http://e.x' }

    it 'has a seal' do
      seal = 'b39ac30cde94634ebfba291e89c901482badda3cddcb126c87c704a87c80e11f'
      subject.seal(subject.data).should eq seal
    end

    it 'has the data string' do
      d = "amount=4575|" \
          "currencyCode=978|" \
          "merchantId=1337|" \
          "normalReturnUrl=http://e.x/omnikassa/success/#{payment.id}/#{subject.payment_token}/|" \
          "automaticResponseUrl=http://e.x/omnikassa/success/automatic/#{payment.id}/#{subject.payment_token}/|"\
          "transactionReference=PREFIX#{order.id}#{payment.id}|" \
          "keyVersion=7"
      subject.data.should eq d
    end
    
    context 'payment data' do
      it 'has the amount in cents' do
        subject.payment_data[:amount].should equal 4575 
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
        subject.payment_data[:normalReturnUrl].should eq "http://e.x/omnikassa/success/#{payment.id}/#{subject.payment_token}/"
      end
 
      it 'has the automatic return url' do
        subject.payment_data[:automaticResponseUrl].should eq "http://e.x/omnikassa/success/automatic/#{payment.id}/#{subject.payment_token}/"
      end

      it 'has the transaction reference' do
        subject.payment_data[:transactionReference].should eq "PREFIX#{order.id}#{payment.id}"
      end
    end
  end
end
