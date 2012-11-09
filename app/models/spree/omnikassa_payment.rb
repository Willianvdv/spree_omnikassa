module Spree
  class OmnikassaPayment < ActiveRecord::Base
    has_many :payments, :as => :source
  
  end
end
