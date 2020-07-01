class RemoveUrlFileToPaymentDetail < ActiveRecord::Migration[6.0]
  def change
  	remove_column :payment_details, :url_file 
  end
end
