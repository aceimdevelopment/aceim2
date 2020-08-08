class AddEnabledQualificationToPeriod < ActiveRecord::Migration[6.0]
  def change
  	add_column :periods, :enabled_qualification, :boolean, default: false
  end
end
