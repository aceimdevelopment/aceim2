class AddCiAndRifToInstructor < ActiveRecord::Migration[6.0]
  def change
  	add_column :instructors, :ci, :string
  	add_column :instructors, :rif, :string
  	add_column :instructors, :bank_account_id, :string 
  	add_foreign_key :instructors, :bank_accounts, on_delete: :cascade, on_update: :cascade
  end
end
