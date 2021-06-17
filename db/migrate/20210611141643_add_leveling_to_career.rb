class AddLevelingToCareer < ActiveRecord::Migration[6.0]
  def change
    add_column :careers, :leveling, :date
  end
end
