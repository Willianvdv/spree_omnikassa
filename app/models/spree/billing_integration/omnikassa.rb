module Spree
  class BillingIntegration::Omnikassa < BillingIntegration
    preference :merchant_id, :string
    preference :secret_key, :string
    preference :key_version, :string

    # Show the confirm step (slightly hackish)
    def payment_profiles_supported?
      true
    end

    attr_accessible :preferred_server,
                    :preferred_test_mode,
                    :preferred_merchant_id, 
                    :preferred_secret_key, 
                    :preferred_key_version

    def provider_class
      puts 'PROVIDER CLASS'
      ActiveMerchant::Billing::Omnikassa 
    end

  end
end
