class CreatePartialQualifications < ActiveRecord::Migration[6.0]
  def change
    create_table :partial_qualifications do |t|
      t.decimal :value, dafault: 0, null: false
      t.references :qualification_schema, null: false, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :academic_record, null: false, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.timestamps
    end
    add_index :partial_qualifications, [:academic_record_id, :qualification_schema_id], unique: true, name: 'unique_record_qualification'
  end
end
