module Spree
  class Gateway::Omnikassa < Gateway
    preference :merchant_id, :string
    preference :secret_key, :string
    preference :key_version, :string

    def provider_class
      nil
    end
  end
end
