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

    describe 'validates' do
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
    end
    
    describe 'payment flow' do
      it 'creates a omnikassa payment object' do
        seal = o.new(payment, '').seal response_data
        spree_post :success, {:payment_id => payment.id, 
                              :token => o.token(payment.id),
                              :Data => response_data,
                              :Seal => seal}
        data = o.new(payment, '').parse_data_string response_data
        omnikassa_payment = Spree::OmnikassaPayment.first
        omnikassa_payment.omnikassa_amount.should eq data[:amount].to_i
        omnikassa_payment.omnikassa_capture_day.should eq data[:captureDay]
        omnikassa_payment.omnikassa_capture_mode.should eq data[:captureMode] 
        omnikassa_payment.omnikassa_currency_code.should eq data[:currencyCode]
        omnikassa_payment.omnikassa_merchant_id.should eq data[:merchantId]
        omnikassa_payment.omnikassa_order_id.should eq data[:orderId]
        omnikassa_payment.omnikassa_transaction_date_time.should eq data[:transactionDateTime]
        omnikassa_payment.omnikassa_transaction_reference.should eq data[:transactionReference]
        omnikassa_payment.omnikassa_authorisation_id.should eq data[:authorisationId]
        omnikassa_payment.omnikassa_key_version.should eq data[:keyVersion]
        omnikassa_payment.omnikassa_payment_mean_brand.should eq data[:paymentMeanBrand]
        omnikassa_payment.omnikassa_payment_mean_type.should eq data[:paymentMeanType]
        omnikassa_payment.omnikassa_response_code.should eq data[:responseCode]
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
  end

  context 'automatic success' do
  end

  context 'error' do
  end

end
