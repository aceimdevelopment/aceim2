class AddResponseCanvasToCoursePeriod < ActiveRecord::Migration[6.0]
  def change
  	add_column :course_periods, :response_unenrolled_canvas, :text
  	add_column :course_periods, :response_unfinded_canvas, :text
  end
end
