class ChangeValueScaleToPartialQualification < ActiveRecord::Migration[6.0]
  def change
    change_column :partial_qualifications, :value, :decimal, {precision: 10, scale: 2, null: true}
  end
end
