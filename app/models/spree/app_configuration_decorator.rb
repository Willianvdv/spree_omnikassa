Spree::AppConfiguration.class_eval do
  preference :omnikassa_merchant_id, :string
  preference :omnikassa_secret_key, :string
  preference :omnikassa_key_version, :string
end
