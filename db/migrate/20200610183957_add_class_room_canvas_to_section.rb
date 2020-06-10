class AddClassRoomCanvasToSection < ActiveRecord::Migration[6.0]
  def change
  	add_column :sections, :url_classroom_canvas, :string
  end
end
