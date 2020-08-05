class AddVarious < ActiveRecord::Migration[6.0]
  def change
  	add_column :sections, :id_canvas, :string 
  	add_column :academic_records, :status_canvas, :integer
  end
end
