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

  before { controller.stub :current_order => order }

  describe 'GET start' do
    it 'assigns a @data string' do
      spree_get :start, :payment_id => payment.id
      assigns(:data).should == 'amount=4575|currencyCode=978|merchantId=1337|normalReturnUrl=http://test.host/omnikassa/success/1/a5a770d4cc/|automaticResponseUrl=http://test.host/omnikassa/success/automatic/1/a5a770d4cc/|transactionReference=PREFIX11|keyVersion=7'
    end

    it 'assigns a @seal' do
      spree_get :start, :payment_id => payment.id
      assigns(:seal).should == '6903457adcd3fa655f1847137628f407bf118a4c0ec4a1b7fafc56cf3de360fe'
    end

    it 'assigns a @url' do
      spree_get :start, :payment_id => payment.id
      assigns(:url).should == 'https://payment-webinit.simu.omnikassa.rabobank.nl/paymentServlet'
    end
  end

  describe 'GET success' do
    def _create_omnikassa_response d={}
      data = "amount=4575|" \
             "captureDay=0|" \
             "captureMode=AUTHOR_CAPTURE|" \
             "currencyCode=978|" \
             "merchantId=1337|" \
             "orderId=null|" \
             "transactionDateTime=2012-11-10T14:04:33+01:00|" \
             "transactionReference=PREFIX#{order.id}#{payment.id}|" \
             "keyVersion=1|" \
             "authorisationId=0020000006791167|" \
             "paymentMeanBrand=IDEAL|" \
             "paymentMeanType=CREDIT_TRANSFER|" \
             "responseCode=#{d[:responseCode] or '00'}"

      secret = Spree::Config[:omnikassa_secret_key]
      seal = (Digest::SHA256.new << "#{data}#{secret}").to_s
      return data, seal
    end

    it 'reject request with invalid seal' do
      spree_post :success, :payment_id => payment.id,
                           :Data => {:field => 'x'},
                           :seal => 'heidi'
      expect(response.response_code).to equal 403
    end

    context 'successfull omnikassa response' do
      before do
        data, seal = _create_omnikassa_response
        spree_post :success, :payment_id => payment.id, :Data => data, :Seal => seal
        @omnikassa_payment = Spree::OmnikassaPayment.last
      end

      it 'has the payment set on the omnikassa_payment' do
        expect(@omnikassa_payment.payment).to eq payment
      end

      it 'sets the payment to completed' do
        pending
      end

      it 'sets the order on the next state' do
        pending
      end

      it 'redirects to the checkout' do
        pending
      end
    end

    context 'unsuccessfull omnikassa response' do
    end
  end

  # #          :omnikassa_amount => data[:amount],
  #         :omnikassa_capture_day => data[:captureDay],
  #         :omnikassa_capture_mode => data[:captureMode],
  #         :omnikassa_currency_code => data[:currencyCode],
  #         :omnikassa_merchant_id => data[:merchantId],
  #         :omnikassa_order_id  => data[:orderId],
  #         :omnikassa_transaction_date_time => data[:transactionDateTime],
  #         :omnikassa_transaction_reference => data[:transactionReference],
  #         :omnikassa_authorisation_id => data[:authorisationId],
  #         :omnikassa_key_version => data[:keyVersion],
  #         :omnikassa_payment_mean_brand => data[:paymentMeanBrand],
  #         :omnikassa_payment_mean_type => data[:paymentMeanType],
  #         :omnikassa_response_code => data[:responseCode],
  #       })

  #{}"amount=#{d[:amount] or '4575'}|" \
  #     "captureDay=0|" \
  #     "captureMode=AUTHOR_CAPTURE|" \
  #     "currencyCode=#{d[:currencyCode] or '978'}|" \
  #     "merchantId=#{d[:merchantId] or Spree::Config.omnikassa_merchant_id}|" \
  #     "orderId=null|" \
  #     "transactionDateTime=2012-11-10T14:04:33+01:00|" \
  #     "transactionReference=PREFIX#{order.id}#{payment.id}|" \
  #     "keyVersion=1|" \
  #     "authorisationId=0020000006791167|" \
  #     "paymentMeanBrand=IDEAL|" \
  #     "paymentMeanType=CREDIT_TRANSFER|" \
  #     "responseCode=#{d[:responseCode] or '00'}"

  # context 'token' do
  #   it 'will respond a 403 if a invalid token is given' do
  #     spree_get :start, {:payment_id => payment.id, :token => 'NOT_VALID_TOKEN'}
  #     response.status.should equal 403
  #   end

  #   it 'will respond a 200 if a valid token is given' do
  #     spree_get :start, {:payment_id => payment.id, :token => o.token(payment.id)}
  #     response.status.should equal 200
  #   end
  # end

  # context 'start' do
  #   it 'has the seal and data set' do
  #     spree_get :start, {:payment_id => payment.id, :token => o.token(payment.id)}
  #     assigns[:seal].should_not be nil
  #     assigns[:data].should_not be nil
  #     response.status.should equal 200
  #   end
  # end

  # context 'success' do
  #   def response_data d={}
  #     "amount=#{d[:amount] or '4575'}|" \
  #     "captureDay=0|" \
  #     "captureMode=AUTHOR_CAPTURE|" \
  #     "currencyCode=#{d[:currencyCode] or '978'}|" \
  #     "merchantId=#{d[:merchantId] or Spree::Config.omnikassa_merchant_id}|" \
  #     "orderId=null|" \
  #     "transactionDateTime=2012-11-10T14:04:33+01:00|" \
  #     "transactionReference=PREFIX#{order.id}#{payment.id}|" \
  #     "keyVersion=1|" \
  #     "authorisationId=0020000006791167|" \
  #     "paymentMeanBrand=IDEAL|" \
  #     "paymentMeanType=CREDIT_TRANSFER|" \
  #     "responseCode=#{d[:responseCode] or '00'}"
  #   end

  #   context 'seal' do
  #     it 'will respond a 403 if an invalid seal is given' do
  #       spree_post :success, {:payment_id => payment.id,
  #                             :token => o.token(payment.id),
  #                             :Data => response_data,
  #                             :Seal => "INVALID_SEAL"}
  #       response.status.should be 403
  #     end

  #     it 'will not respond with a 403 if a valid seal is given' do
  #       seal = o.new(payment, '').seal response_data
  #       spree_post :success, {:payment_id => payment.id,
  #                             :token => o.token(payment.id),
  #                             :Data => response_data,
  #                             :Seal => seal}
  #       response.status.should_not be 403
  #     end
  #   end

  #   describe 'validates' do
  #     it 'gives a 403 if the amount is changed' do
  #       seal = o.new(payment, '').seal response_data
  #       spree_post :success, {:payment_id => payment.id,
  #                            :token => o.token(payment.id),
  #                            :Data => response_data({:amount => '100'}),
  #                            :Seal => seal}
  #       response.status.should be 403
  #     end

  #     it 'gives a 403 if the currency code is changed' do
  #       seal = o.new(payment, '').seal response_data
  #       spree_post :success, {:payment_id => payment.id,
  #                             :token => o.token(payment.id),
  #                            :Data => response_data({:currencyCode => '666'}),
  #                            :Seal => seal}
  #       response.status.should be 403
  #     end

  #     it 'gives a 403 if the merchant id is changed' do
  #       seal = o.new(payment, '').seal response_data
  #       spree_post :success, {:payment_id => payment.id,
  #                             :token => o.token(payment.id),
  #                             :Data => response_data({:merchantId => '9999'}),
  #                             :Seal => seal}
  #       response.status.should be 403
  #     end
  #   end

  #   describe 'payment flow' do
  #     before(:each) do
  #       payment.send('started_processing!')
  #       payment.save
  #     end



  #     it 'creates a omnikassa payment object' do
  #       reponse_data = _post
  #       data = o.new(payment, '').parse_data_string response_data
  #       omnikassa_payment = Spree::OmnikassaPayment.first
  #       omnikassa_payment.omnikassa_amount.should eq data[:amount].to_i
  #       omnikassa_payment.omnikassa_capture_day.should eq data[:captureDay]
  #       omnikassa_payment.omnikassa_capture_mode.should eq data[:captureMode]
  #       omnikassa_payment.omnikassa_currency_code.should eq data[:currencyCode]
  #       omnikassa_payment.omnikassa_merchant_id.should eq data[:merchantId]
  #       omnikassa_payment.omnikassa_order_id.should eq data[:orderId]
  #       omnikassa_payment.omnikassa_transaction_date_time.should eq data[:transactionDateTime]
  #       omnikassa_payment.omnikassa_transaction_reference.should eq data[:transactionReference]
  #       omnikassa_payment.omnikassa_authorisation_id.should eq data[:authorisationId]
  #       omnikassa_payment.omnikassa_key_version.should eq data[:keyVersion]
  #       omnikassa_payment.omnikassa_payment_mean_brand.should eq data[:paymentMeanBrand]
  #       omnikassa_payment.omnikassa_payment_mean_type.should eq data[:paymentMeanType]
  #       omnikassa_payment.omnikassa_response_code.should eq data[:responseCode]
  #     end

  #     it 'sets a reference from the omnikassa payment to the payment' do
  #       data = _post({:responseCode => '00'})
  #       omnikassa_payment = Spree::OmnikassaPayment.first
  #       omnikassa_payment.payment.id.should equal payment.id
  #     end

  #     it 'sets the state to complete if 00 responseCode is given' do
  #       data = _post({:responseCode => '00'})
  #       payment.reload
  #       payment.state.should eq 'completed'
  #     end

  #     it 'sets the state to pending if 60 responseCode is given' do
  #       data = _post({:responseCode => '60'})
  #       payment.reload
  #       payment.state.should eq 'pending'
  #     end

  #     it 'sets the state to failed responseCode is not 60(pending) or 00(success)' do
  #       data = _post({:responseCode => '99'})
  #       payment.reload
  #       payment.state.should eq 'failed'
  #     end

  #     it 'redirects user' do
  #       _post
  #       response.status.should be 302
  #     end
  #   end
  # end

  # context 'automatic success' do
  # end

  # context 'error' do
  #   it 'response with a 200' do
  #     spree_post :error, {:payment_id => payment.id,
  #                         :token => o.token(payment.id)}
  #     response.status.should be 200
  #   end
  # end

end
