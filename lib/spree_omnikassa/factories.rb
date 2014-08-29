FactoryGirl.define do
  factory :omnikassa_payment_method, class: Spree::PaymentMethod::Omnikassa do
    name 'Omnikassa'
    environment 'test'
  end
end
