class CreateQualificationStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :qualification_statuses, id: false do |t|
      t.string :id, null: false, primary_key: true, index: true
      t.string :name
    end
  end
end
