class CreateAgreements < ActiveRecord::Migration[6.0]
  def change
    create_table :agreements, id: false do |t|
      t.string :id, null: false, primary_key: true, index: true
      t.string :name
      t.decimal :value
      t.integer :discount

      t.timestamps
    end
  end
end
