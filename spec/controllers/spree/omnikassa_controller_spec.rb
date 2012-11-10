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
end
