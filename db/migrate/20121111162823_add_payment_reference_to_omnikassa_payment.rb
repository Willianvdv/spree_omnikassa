class AddPaymentReferenceToOmnikassaPayment < ActiveRecord::Migration
  def change
    add_column :spree_omnikassa_payments, :payment_id, :integer
  end
end
