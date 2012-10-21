module Spree
  class OmnikassaPaymentMethod
  end

  class Gateway::Omnikassa < Gateway
    preference :merchant_id, :string
    preference :secret_key, :string
    preference :key_version, :string

    attr_accessible :preferred_merchant_id, 
                    :preferred_secret_key, 
                    :preferred_key_version

    def payment_source_class
      puts 'SOUIRERNENERNERNEN1:we'
      return Spree::OmnikassaPaymentMethod
    end
  end
end
