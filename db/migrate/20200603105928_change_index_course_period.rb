class ChangeIndexCoursePeriod < ActiveRecord::Migration[6.0]
  def change
  	remove_index :course_periods, [:period_id, :course_id]
  	add_index :course_periods, [:period_id, :course_id, :kind], unique: true
  end
end
