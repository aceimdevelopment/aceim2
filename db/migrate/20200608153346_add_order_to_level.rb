class AddOrderToLevel < ActiveRecord::Migration[6.0]
  def change
  	add_column :levels, :grade, :integer, null: false
  end
end
