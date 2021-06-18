class AddLevelingToCareer < ActiveRecord::Migration[6.0]
  def change
    add_column :careers, :leveling_period_id, :bigint
    add_foreign_key :careers, :periods, column: :leveling_period_id, on_delete: :cascade, on_update: :cascade, index: true
  end
end
