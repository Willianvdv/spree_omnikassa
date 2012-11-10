require 'spec_helper'

describe Spree::OmnikassaController do
  include_context 'omnikassa'

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
    def response_data d={}
      "amount=#{d[:amount] or '4575'}|" \
      "captureDay=0|" \
      "captureMode=AUTHOR_CAPTURE|" \
      "currencyCode=#{d[:currencyCode] or '978'}|" \
      "merchantId=#{d[:merchantId] or Spree::Config.omnikassa_merchant_id}|" \
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
        spree_post :success, {:payment_id => payment.id, 
                              :token => o.token(payment.id),
                              :Data => response_data,
                              :Seal => "INVALID_SEAL"}
        response.status.should be 403
      end

      it 'will not respond with a 403 if a valid seal is given' do
        seal = o.new(payment, '').seal response_data
        spree_post :success, {:payment_id => payment.id, 
                              :token => o.token(payment.id),
                              :Data => response_data,
                              :Seal => seal}
        response.status.should_not be 403
      end
    end
   
    it 'gives a 403 if the amount is changed' do
      seal = o.new(payment, '').seal response_data
      spree_post :success, {:payment_id => payment.id, 
                            :token => o.token(payment.id),
                            :Data => response_data({:amount => '100'}),
                            :Seal => seal}
      response.status.should be 403    
    end

    it 'gives a 403 if the currency code is changed' do
      seal = o.new(payment, '').seal response_data
      spree_post :success, {:payment_id => payment.id, 
                            :token => o.token(payment.id),
                            :Data => response_data({:currencyCode => '666'}),
                            :Seal => seal}
      response.status.should be 403    
    end

    it 'gives a 403 if the merchant id is changed' do
      seal = o.new(payment, '').seal response_data
      spree_post :success, {:payment_id => payment.id, 
                            :token => o.token(payment.id),
                            :Data => response_data({:merchantId => '9999'}),
                            :Seal => seal}
      response.status.should be 403    
    end

    it 'redirects user' do
      seal = o.new(payment, '').seal response_data
      spree_post :success, {:payment_id => payment.id, 
                              :token => o.token(payment.id),
                              :Data => response_data,
                              :Seal => seal}
      response.status.should be 302
    end
  end

  context 'automatic success' do
  end

  context 'error' do
  end

end
