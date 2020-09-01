class AddAltEmailToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :canvas_email, :string
  end
end
