module Spree
  class BillingIntegration::Omnikassa < BillingIntegration
    preference :merchant_id, :string
    preference :secret_key, :string
    preference :key_version, :string

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

    #def redirect_url order, opts = {}
    #  'http://www.google.nl'
    #end

    #def payment_source_class
    #  nil #Spree::Omnikassa
    #end
  end
end
