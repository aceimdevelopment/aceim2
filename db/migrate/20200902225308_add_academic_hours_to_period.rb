class AddAcademicHoursToPeriod < ActiveRecord::Migration[6.0]
  def change
  	add_column :periods, :academic_hours, :integer, default: 48
  end
end
