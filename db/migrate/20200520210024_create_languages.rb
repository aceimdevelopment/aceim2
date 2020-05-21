class CreateLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :languages, id: false do |t|
      t.string :name
      t.string :id, null: false, primary_key: true, index: true

      t.timestamps
    end
  end
end
