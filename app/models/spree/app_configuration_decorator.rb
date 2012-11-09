Spree::AppConfiguration.class_eval do
  preference :omnikassa_merchant_id, :string
  preference :omnikassa_secret_key, :string
  preference :omnikassa_key_version, :string
  preference :omnikassa_transaction_reference_prefix, :string
end
