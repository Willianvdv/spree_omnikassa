require 'spec_helper'

describe Spree::OmnikassaController do
  let(:order) do
    FactoryGirl.create :order 
  end

  before { controller.stub :current_order => order}

  context 'valid token' do

    it 'will respond a 404 if a invalid token is given' do
      spree_get :start
      puts response
    end
  
  end

end
