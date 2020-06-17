class AddIdCanvasToCoursePeriod < ActiveRecord::Migration[6.0]
  def change
  	add_column :course_periods, :id_canvas, :string
  end
end
