class AddDescriptionToPaymentDetail < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_details, :description, :string
  end
end
