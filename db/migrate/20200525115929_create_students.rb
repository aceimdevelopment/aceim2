class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students, id: false do |t|
      t.references :user, null: false, primary_key: true
      t.boolean :active, default: true
      t.string :personal_identity_document, unique: true
      t.string :location
      t.string :source_country      
      t.timestamps
    end
    add_foreign_key :students, :users, column: :user_id, on_delete: :cascade, on_update: :cascade
  end
end