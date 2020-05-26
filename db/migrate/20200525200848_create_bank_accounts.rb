class CreateBankAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_accounts, id: false do |t|
      t.string :id, null: false, primary_key: true, index: true
      t.string :number, null: false
      t.string :holder, null: false
      t.references :bank, null: false, type: :string, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.timestamps
    end
  end
end
