class CreateSections < ActiveRecord::Migration[6.0]
  def change
    create_table :sections do |t|
      t.string :number, null: false
      t.references :course_period, null: false, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :instructor, foreign_key: {primary_key: :user_id, on_delete: :cascade, on_update: :cascade}
      t.references :evaluator, foreign_key: {to_table: :instructors, primary_key: :user_id, on_delete: :cascade, on_update: :cascade}
      t.boolean :open
      t.index [:number, :course_period_id], unique: true

      t.timestamps
    end
  end
end