class CreateAcademicRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :academic_records, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.references :student, null: false
      t.references :section, null: false
      # t.string :agreement_id, null: false, default: 'REG'
      t.references :agreement, null: false, type: :string, dafault: 'REG'
      t.references :qualification_status, null: false, type: :string
      t.integer :inscription_status, null: false, default: 0
      t.float :final_qualification
      t.timestamps
    end
    add_foreign_key :academic_records, :students, primary_key: :user_id, on_delete: :cascade, on_update: :cascade
    add_foreign_key :academic_records, :sections, on_delete: :cascade, on_update: :cascade
    add_foreign_key :academic_records, :agreements, on_delete: :cascade, on_update: :cascade
    add_foreign_key :academic_records, :qualification_statuses, on_delete: :cascade, on_update: :cascade
    add_index :academic_records, [:student_id, :section_id], unique: true
  end
end
