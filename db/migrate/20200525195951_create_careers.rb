class CreateCareers < ActiveRecord::Migration[6.0]
  def change
    create_table :careers do |t|
      t.references :agreement, null: false, foreign_key: {on_delete: :cascade, on_update: :cascade}, type: :string, default: 'REG'
      t.references :language, null: false, foreign_key: {on_delete: :cascade, on_update: :cascade}, type: :string
      t.references :student, null: false, foreign_key: {primary_key: :user_id, on_delete: :cascade, on_update: :cascade}

      t.timestamps
    end
  end
end