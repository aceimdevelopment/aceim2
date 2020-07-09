class CreateQualificationSchemas < ActiveRecord::Migration[6.0]
  def change
    create_table :qualification_schemas do |t|
      t.integer :percentage, default: 0, null: false
      t.references :period, null: false, foreign_key: true
      t.integer :sequence, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :qualification_schemas, [:period_id, :sequence], unique: true

  end
end
