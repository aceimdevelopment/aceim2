class TotalPercentageValidator < ActiveModel::Validator
  def validate(record)
    if more_that_onehunder(record)
      record.errors.add 'La suma', 'de los esquemas debe ser menor o igual que 100'
    end
  end

  private
    def more_that_onehunder(record)
      total_percentage = record.period.qualification_schemas.where('id != ?', record.id).sum(:percentage)
      record.percentage+total_percentage > 100
    end
end