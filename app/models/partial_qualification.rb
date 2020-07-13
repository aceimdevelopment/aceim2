class PartialQualification < ApplicationRecord
  belongs_to :qualification_schema, inverse_of: :partial_qualifications
  belongs_to :academic_record, inverse_of: :partial_qualifications
  validates :value, presence: true

  after_save :set_final


  private

  def set_final
    self.academic_record.update(final_qualification: self.academic_record.calculate_final)
  end

end
