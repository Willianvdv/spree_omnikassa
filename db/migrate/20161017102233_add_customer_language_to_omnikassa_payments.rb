class AddCustomerLanguageToOmnikassaPayments < ActiveRecord::Migration
  def change
    add_column :spree_omnikassa_payments, :omnikassa_customer_language, :string
  end
end
