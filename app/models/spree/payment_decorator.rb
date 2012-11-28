Spree::Payment.class_eval do
  has_one :omnikassa_payment
end
