class OmnikassaExtension < Spree::Extension
  version "0.1"
  description "Omnikassa payment extension"
  
  def activate
    BillingIntegration::Omnikassa.register
  end
end
