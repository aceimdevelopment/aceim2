class CreateContents < ActiveRecord::Migration[6.0]
  def change
    create_table :contents do |t|
      t.string :title
      t.string :description
      t.string :url
      t.integer :category
      t.boolean :published, default: true

      t.timestamps
    end
  end
end
