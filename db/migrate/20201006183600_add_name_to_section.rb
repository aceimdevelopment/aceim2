class AddNameToSection < ActiveRecord::Migration[6.0]
  def change
  	add_column :sections, :name, :string
  end
end
