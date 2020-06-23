class AddEnableEnrollmentToPeriod < ActiveRecord::Migration[6.0]
  def change
    add_column :periods, :enrollment, :boolean, default: false
  end
end
