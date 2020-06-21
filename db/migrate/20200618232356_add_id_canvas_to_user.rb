class AddIdCanvasToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :id_canvas, :string
  end
end
