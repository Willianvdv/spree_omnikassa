require 'spec_helper'

describe Spree::OmnikassaController do
  let(:order) do
    FactoryGirl.create :order 
  end

  before { controller.stub :current_order => order}

end
