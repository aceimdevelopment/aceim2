class AddCustomerNameToPaymentDetail < ActiveRecord::Migration[6.0]
  def change
  	add_column :payment_details, :customer_name, :string
  end
end
