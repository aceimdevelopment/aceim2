class AddAccountTypeToBankAccount < ActiveRecord::Migration[6.0]
  def change
  	add_column :bank_accounts, :account_type, :integer, null: false
  	add_column :bank_accounts, :own, :boolean, default: false
  end
end
