Spree::Payment.class_eval do
  has_many :omnikassa_payments
end
