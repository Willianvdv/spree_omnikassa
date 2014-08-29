module Spree
  class PaymentMethod::Omnikassa < PaymentMethod
    def cancel(response_code); end

    def source_attributes
      true
    end

    # Still not sure what a source is
    def source_required?
      false
    end

    def payment_source_class
       Spree::Omnikassa
    end
  end
end
