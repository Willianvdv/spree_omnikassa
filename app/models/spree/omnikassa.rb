module Spree
  class Omnikassa < ActiveRecord::Base
    has_many :payments, :as => :source
  
  end
end
