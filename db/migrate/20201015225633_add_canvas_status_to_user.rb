class AddCanvasStatusToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :canvas_status, :integer, null: false, default: 0
  end
end
