class CreateBanks < ActiveRecord::Migration[6.0]
  def change
    create_table :banks, id: false do |t|
      t.string :id, null: false, primary_key: true, index: true
      t.string :name

      t.timestamps
    end
  end
end
