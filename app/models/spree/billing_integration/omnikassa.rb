module Spree
  class BillingIntegration::Omnikassa < BillingIntegration
    preference :merchant_id, :string
    preference :secret_key, :string
    preference :key_version, :string

    attr_accessible :preferred_merchant_id, 
                    :preferred_secret_key, 
                    :preferred_key_version
  end
end
