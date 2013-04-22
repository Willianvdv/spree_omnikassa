require 'spec_helper'

def _create_omnikassa_response d={}
  data = "amount=4575|" \
         "captureDay=0|" \
         "captureMode=AUTHOR_CAPTURE|" \
         "currencyCode=978|" \
         "merchantId=1337|" \
         "orderId=null|" \
         "transactionDateTime=2012-11-10T14:04:33+01:00|" \
         "transactionReference=PREFIX#{@payment.order.id}#{@payment.id}|" \
         "keyVersion=1|" \
         "authorisationId=0020000006791167|" \
         "paymentMeanBrand=IDEAL|" \
         "paymentMeanType=CREDIT_TRANSFER|" \
         "responseCode=#{d[:response_code] or '00'}"

  secret = Spree::Config[:omnikassa_secret_key]
  seal = (Digest::SHA256.new << "#{data}#{secret}").to_s
  return data, seal
end

describe Spree::OmnikassaController do
  include_context 'omnikassa'

  let(:order) do
    @payment.order
  end

  let(:o) do
    Spree::Omnikassa
  end

  before :each do
    @payment = FactoryGirl.create :payment
    controller.stub!(:authorize!)
  end

  describe 'GET start' do
    describe 'assignment' do
      it 'assigns a @data string' do
        spree_get :start, :payment_id => @payment.id
        assigns(:data).should == 'amount=4575|currencyCode=978|merchantId=1337|normalReturnUrl=http://test.host/omnikassa/success/1/|automaticResponseUrl=http://test.host/omnikassa/success/automatic/1/|transactionReference=PREFIX11|keyVersion=7'
      end

      it 'assigns a @seal' do
        spree_get :start, :payment_id => @payment.id
        assigns(:seal).should == 'be356b07401bd7aa891897ae649a6af790ac940d8fa698407a84aac4678b63cf'
      end

      it 'assigns a @url' do
        spree_get :start, :payment_id => @payment.id
        assigns(:url).should == 'https://payment-webinit.simu.omnikassa.rabobank.nl/paymentServlet'
      end
    end

    it 'sets the state to processing' do
      spree_get :start, :payment_id => @payment.id
      @payment.reload
      expect(@payment.state).to eq('processing')
    end
  end

  describe 'GET success' do
    before :each do
      @payment.send(:started_processing!)
    end

    it 'reject request with invalid seal' do
      spree_post :success, :payment_id => @payment.id, :Data => {:field => 'x'}, :seal => 'heidi'
      expect(response.response_code).to equal 403
    end

    context 'with successfull omnikassa response' do
      before do
        data, seal = _create_omnikassa_response
        spree_post :success, :payment_id => @payment.id, :Data => data, :Seal => seal
      end

      it 'sets the payment state to completed' do
        @payment.reload
        expect(@payment.state).to eq 'completed'
      end

      it 'redirects to the checkout' do
        u = "http://test.host/orders/#{@payment.order.number}"
        expect(response.response_code).to redirect_to(u)
      end
    end

    context 'with pending state omnikassa response' do
      before do
        data, seal = _create_omnikassa_response({:response_code => '60'})
        spree_post :success, :payment_id => @payment.id, :Data => data, :Seal => seal
      end

      it 'sets the payment state to pending' do
        @payment.reload
        expect(@payment.state).to eq 'pending'
      end

      it 'sets the order on the next state' do
        expect(@payment.order.state).not_to eq 'payment'
      end

      it 'redirects to the checkout' do
        u = "http://test.host/omnikassa/pending/#{@payment.id}/"
        expect(response.response_code).to redirect_to(u)
      end
    end

    context 'with failed state omnikassa response' do
      before do
        data, seal = _create_omnikassa_response({:response_code => '99'})
        spree_post :success, :payment_id => @payment.id, :Data => data, :Seal => seal
      end

      it 'sets the payment state to failed' do
        @payment.reload
        expect(@payment.state).to eq 'failed'
      end

      it 'redirects to the omnikassa error action' do
        u = "http://test.host/omnikassa/error/#{@payment.id}/"
        expect(response.response_code).to redirect_to(u)
      end
    end

    describe 'GET automatic_success' do
      context 'with success state omnikassa response' do
        before do
          # Normal success call
          data, seal = _create_omnikassa_response
          spree_post :success, :payment_id => @payment.id, :Data => data, :Seal => seal

          # Automatic success call
          data, seal = _create_omnikassa_response
          spree_post :success_automatic, :payment_id => @payment.id, :Data => data, :Seal => seal
        end

        it 'sets the payment state to completed' do
          @payment.reload
          expect(@payment.state).to eq 'completed'
        end

      end

      context 'with failed state omnikassa response' do
        before do
          # Normal success call
          data, seal = _create_omnikassa_response({:response_code => '99'})
          spree_post :success, :payment_id => @payment.id, :Data => data, :Seal => seal

          # Automatic success call
          data, seal = _create_omnikassa_response({:response_code => '99'})
          spree_post :success_automatic, :payment_id => @payment.id, :Data => data, :Seal => seal
        end

        it 'sets the payment state to failed' do
          @payment.reload
          expect(@payment.state).to eq 'failed'
        end
      end

      context 'with pending state omnikassa response' do
        before do
          # Normal success call
          data, seal = _create_omnikassa_response({:response_code => '60'})
          spree_post :success, :payment_id => @payment.id, :Data => data, :Seal => seal

          # Automatic success call
          data, seal = _create_omnikassa_response({:response_code => '60'})
          spree_post :success_automatic, :payment_id => @payment.id, :Data => data, :Seal => seal
        end

        it 'sets the payment state to pending' do
          @payment.reload
          expect(@payment.state).to eq 'pending'
        end
      end

    end
  end
end
