module Spree
  class BillingIntegration::Omnikassa < BillingIntegration
    preference :merchant_id, :string
    preference :secret_key, :string
    preference :key_version, :string

    attr_accessible :preferred_server,
                    :preferred_test_mode,
                    :preferred_merchant_id, 
                    :preferred_secret_key, 
                    :preferred_key_version

    # Show the confirm step (slightly hackish)
    def payment_profiles_supported?
      true
    end

    def source_attributes
      true
    end

    # Still not sure what a source is
    def source_required?
      false
    end

    def payment_source_class
       Spree::Omnikassa
    end
  end
end
