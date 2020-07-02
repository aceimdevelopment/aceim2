class AddReadReportedAndReadConfirmedToPaymentDetails < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_details, :read_report, :boolean, default: false
    add_column :payment_details, :read_confirmation, :boolean, default: false
  end
end
