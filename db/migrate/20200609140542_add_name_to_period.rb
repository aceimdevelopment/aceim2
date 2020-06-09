class AddNameToPeriod < ActiveRecord::Migration[6.0]
  def change
  	add_column :periods, :name, :string
  end
end
