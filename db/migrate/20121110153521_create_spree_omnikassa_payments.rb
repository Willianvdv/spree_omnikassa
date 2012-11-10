class CreateSpreeOmnikassaPayments < ActiveRecord::Migration
  def change
    create_table :omnikassa_payments do |t|
      t.integer :omnikassa_amount
      t.string :omnikassa_capture_day
      t.string :omnikassa_capture_mode
      t.string :omnikassa_currency_code
      t.string :omnikassa_merchant_id
      t.string :omnikassa_order_id
      t.string :omnikassa_transaction_date_time
      t.string :omnikassa_transaction_reference
      t.string :omnikassa_authorisation_id
      t.string :omnikassa_key_version
      t.string :omnikassa_payment_mean_brand
      t.string :omnikassa_payment_mean_type
      t.string :omnikassa_response_code
      t.timestamps
    end
  end
end
