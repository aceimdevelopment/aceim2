class CreateBillboards < ActiveRecord::Migration[6.0]
  def change
    create_table :billboards do |t|
      t.string :name
      t.boolean :enabled, null: false, default: false
      t.integer :sequence
      t.timestamps
    end
  end
end
