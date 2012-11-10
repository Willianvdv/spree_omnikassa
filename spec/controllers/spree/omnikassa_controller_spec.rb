require 'spec_helper'

describe Spree::OmnikassaController do
  let(:payment) do
    FactoryGirl.create :payment
  end

  let(:order) do
    payment.order
  end

  let(:o) do
    Spree::Omnikassa
  end

  before { controller.stub :current_order => order}

  context 'token' do
    it 'will respond a 403 if a invalid token is given' do
      spree_get :start, {:payment_id => payment.id, :token => 'NOT_VALID_TOKEN'}
      response.status.should equal 403
    end

    it 'will respond a 200 if a valid token is given' do
      spree_get :start, {:payment_id => payment.id, :token => o.token(payment.id)}
      response.status.should equal 200
    end
  end

  context 'start' do
    it 'has the seal and data set' do
      spree_get :start, {:payment_id => payment.id, :token => o.token(payment.id)}
      assigns[:seal].should_not be nil
      assigns[:data].should_not be nil
      response.status.should equal 200
    end
  end

  context 'success' do
    let(:response_data) do
      "amount=4575|" \
      "captureDay=0|" \
      "captureMode=AUTHOR_CAPTURE|" \
      "currencyCode=978|" \
      "merchantId=#{Spree::Config.omnikassa_merchant_id}|" \
      "orderId=null|" \
      "transactionDateTime=2012-11-10T14:04:33+01:00|" \
      "transactionReference=PREFIX#{order.id}#{payment.id}|" \
      "keyVersion=1|" \
      "authorisationId=0020000006791167|" \
      "paymentMeanBrand=IDEAL|" \
      "paymentMeanType=CREDIT_TRANSFER|" \
      "responseCode=00"
    end

    context 'seal' do
      it 'will respond a 403 if an invalid seal is given' do
        spree_post :success, {:payment_id => payment.id, :token => o.token(payment.id)}
        response.status.should be 403
      end

      it 'will not respond 403 if an valid seal is given' do
        s = '95dd82dc2abfb432313aa37908627cd8934d1344cf1842bf66ecc0584dc6e2e4'
        spree_post :success, {:payment_id => payment.id, 
                              :token => o.token(payment.id),
                              :Data => response_data,
                              :Seal => s}
        response.status.should_not be 403
      end
    end
  end

  context 'automatic success' do
  end

  context 'error' do
  end

end
