module Spree
  class OmnikassaPayment < ActiveRecord::Base
    belongs_to :payment

    def self.processor(payment)
      OmnikassaProcessor.new payment
    end
  end
end
