class CreateCoursePeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :course_periods do |t|
      t.references :course, null: false, foreign_key: true
      t.references :period, null: false, foreign_key: true

      t.timestamps
    end
  end
end
