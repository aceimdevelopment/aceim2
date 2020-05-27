class CreateQualificationDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :qualification_details do |t|
      t.references :section, null: false, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :qualifier, null: false, foreign_key: {to_table: :instructors, primary_key: :user_id, on_delete: :cascade, on_update: :cascade}
      t.date :qualification_date
      t.boolean :qualified, null: false, default: false

      t.timestamps
    end
  end
end
