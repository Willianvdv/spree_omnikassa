module Spree
  class OmnikassaPayment < ActiveRecord::Base
    attr_accessible :omnikassa_amount
                    :omnikassa_capture_day
                    :omnikassa_capture_mode
                    :omnikassa_currency_code
                    :omnikassa_merchant_id
                    :omnikassa_order_id
                    :omnikassa_transaction_date_time
                    :omnikassa_transaction_reference
                    :omnikassa_authorisation_id
                    :omnikassa_key_version
                    :omnikassa_payment_mean_brand
                    :omnikassa_payment_mean_type
                    :omnikassa_response_code
  end
end
