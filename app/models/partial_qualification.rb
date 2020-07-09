class PartialQualification < ApplicationRecord
  belongs_to :qualification_schema, inverse_of: :partial_qualifications
  belongs_to :academic_record, inverse_of: :partial_qualifications
  validates :value, presence: true

  after_save :set_final


  private

  def set_final
    self.academic_record.update_final
  end

end
