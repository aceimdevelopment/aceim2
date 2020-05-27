class CreatePaymentDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_details do |t|
      t.string :transaction_number, null: false, unique: true
      t.references :bank_account, null: false, type: :string, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :source_bank, type: :string, foreign_key: {to_table: :banks, on_delete: :cascade, on_update: :cascade}
      t.references :academic_record, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.integer :transaction_type

      t.timestamps
    end
  end
end
