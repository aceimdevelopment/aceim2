class CreateInstructors < ActiveRecord::Migration[6.0]
  def change
    create_table :instructors, id: false do |t|
      t.references :user, null: false, primary_key: true
      t.boolean :active, null: false, default: true
      t.timestamps
    end
    add_foreign_key :instructors, :users, column: :user_id, on_delete: :cascade, on_update: :cascade
  end
end
