module Spree
  class PaymentMethod::Omnikassa < PaymentMethod
    #attr_accessible :preferred_server,
    #                :preferred_test_mode

    # Show the confirm step (slightly hackish)
    def payment_profiles_supported?
      true
    end

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
