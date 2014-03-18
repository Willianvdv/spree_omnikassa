FactoryGirl.define do
  factory :omnikassa_payment_method, class: Spree::BillingIntegration::Omnikassa do
    name 'Omnikassa'
    environment 'test'
  end
end
