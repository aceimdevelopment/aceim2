class CreateGeneralSetups < ActiveRecord::Migration[6.0]
  def change
    create_table :general_setups, id: false do |t|
      t.string :id, primary_key: true, null: false, index: true
      t.string :value 
    end
  end
end
