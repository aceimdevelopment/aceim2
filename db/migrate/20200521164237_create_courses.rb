class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.references :language, null: false, type: :string
      t.references :level, null: false, type: :string
      t.integer :grade

      t.timestamps
    end
    add_foreign_key :courses, :languages, on_delete: :cascade, on_update: :cascade, index: true
    add_foreign_key :courses, :levels, on_delete: :cascade, on_update: :cascade, index: true
    add_index :courses, [:level_id, :language_id], unique: true

  end
end
