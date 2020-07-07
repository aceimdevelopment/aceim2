class AddCapacityToCoursePeriod < ActiveRecord::Migration[6.0]
  def change
  	add_column :course_periods, :capacity, :integer, default: 25
  end
end
