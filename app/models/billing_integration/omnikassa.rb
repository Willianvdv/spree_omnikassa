class BillingIntegration::Omnikassa < BillingIntergration
  preference :merchant_id, :string
  preference :key_version, :integer
  preference :secret_key, :string

  def payment_source_class
    OmniKassa
  end
end
