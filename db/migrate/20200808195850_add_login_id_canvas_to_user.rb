class AddLoginIdCanvasToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :login_id_canvas, :string
  end
end
