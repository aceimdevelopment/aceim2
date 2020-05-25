class CreateAdministrators < ActiveRecord::Migration[6.0]
  def change
    create_table :administrators, id: false do |t|
      t.references :user, null: false, primary_key: true
      t.integer :role, null: false, default: 0
      t.timestamps
    end
    add_foreign_key :administrators, :users, column: :user_id, on_delete: :cascade, on_update: :cascade
  end
end
