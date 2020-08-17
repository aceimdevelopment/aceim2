class ChangeValueToPartialQualification < ActiveRecord::Migration[6.0]
  def change
  	change_column :partial_qualifications, :value, :decimal, {null: true}
  end
end
