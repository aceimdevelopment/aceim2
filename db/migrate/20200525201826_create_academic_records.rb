class CreateAcademicRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :academic_records do |t|
      t.references :student, null: false
      t.references :section, null: false
      t.references :agreement, null: false, type: :string, dafault: 'REG'
      t.integer :status, null: false
      t.float :final_qualification
      t.boolean :qualified, null: false, default: false
      t.timestamps
    end
    add_foreign_key :academic_records, :students, primary_key: :user_id, on_delete: :cascade, on_update: :cascade
    add_foreign_key :academic_records, :sections, on_delete: :cascade, on_update: :cascade
    add_foreign_key :academic_records, :agreements, on_delete: :cascade, on_update: :cascade
  end
end
