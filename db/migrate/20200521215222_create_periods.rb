class CreatePeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :periods do |t|
      t.integer :year
      t.string :letter
      t.integer :kind

      t.timestamps
    end
  end
end
