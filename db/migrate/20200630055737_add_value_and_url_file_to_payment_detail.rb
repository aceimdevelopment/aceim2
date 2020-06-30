class AddValueAndUrlFileToPaymentDetail < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_details, :mount, :string, null: false
    add_column :payment_details, :url_file, :string
  end
end
