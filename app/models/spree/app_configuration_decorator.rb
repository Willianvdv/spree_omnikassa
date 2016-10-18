Spree::AppConfiguration.class_eval do
  preference :omnikassa_url, :string, :default => 'https://payment-webinit.simu.omnikassa.rabobank.nl/paymentServlet'
  preference :omnikassa_merchant_id, :string, :default => '002020000000001'
  preference :omnikassa_secret_key, :string, :default => '002020000000001_KEY1'
  preference :omnikassa_key_version, :string, :default => '1'
  preference :omnikassa_transaction_reference_prefix, :string, :default => 'PREFIX'
  preference :omnikassa_customer_language, :string, :default => 'NL'
end
