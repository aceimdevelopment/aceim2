class AddImportedToStudent < ActiveRecord::Migration[6.0]
  def change
  	add_column :students, :imported, :boolean, default: false, null: false
  end
end
