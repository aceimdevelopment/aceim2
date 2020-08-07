class ChangeDataTypeToNumberSection < ActiveRecord::Migration[6.0]
  def change
  	change_column :sections, :number, :integer
  end
end
