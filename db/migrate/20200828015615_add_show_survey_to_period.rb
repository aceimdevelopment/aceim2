class AddShowSurveyToPeriod < ActiveRecord::Migration[6.0]
  def change
  	add_column :periods, :show_survey, :boolean, {default: false}
  end
end
