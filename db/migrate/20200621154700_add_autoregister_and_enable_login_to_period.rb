class AddAutoregisterAndEnableLoginToPeriod < ActiveRecord::Migration[6.0]
  def change
    add_column :periods, :enabled_autoregister_canvas_link, :boolean
    add_column :periods, :enabled_login_canvas_link, :boolean, default: false
  end
end
