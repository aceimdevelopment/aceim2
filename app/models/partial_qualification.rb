class PartialQualification < ApplicationRecord
  belongs_to :qualification_schema, inverse_of: :partial_qualifications
  belongs_to :academic_record, inverse_of: :partial_qualifications
  # validates :value, presence: true

  after_save :set_final, unless: :new_record? 

  # ======================== SCOPES =============================#
  # ========== qualification_schema_and_language  ===============#
  scope :from_qualification_schema_and_language, -> (qs_id, language_id) {joins(academic_record: {section: {course_period: {course: :language}}}).where('qualification_schema_id = ? AND languages.id = ?', qs_id, language_id)}
  scope :from_qualification_schema_and_language_not_qualified, -> (qs_id, language_id) {joins(academic_record: {section: {course_period: {course: :language}}}).where('qualification_schema_id = ? AND languages.id = ? AND value IS NULL', qs_id, language_id)}
  scope :from_qualification_schema_and_language_qualified, -> (qs_id, language_id) {joins(academic_record: {section: {course_period: {course: :language}}}).where('qualification_schema_id = ? AND languages.id = ? AND value IS NOT NULL', qs_id, language_id)}

  # ========== qualification_schema_and_course_period  ===============#
  scope :from_qualification_schema_and_course_period, -> (qs_id, cp_id) {joins(academic_record: {section: :course_period}).where('qualification_schema_id = ? AND course_periods.id = ?', qs_id, cp_id)}
  scope :from_qualification_schema_and_course_period_not_qualified, -> (qs_id, cp_id) {joins(academic_record: {section: :course_period}).where('qualification_schema_id = ? AND course_periods.id = ? AND value IS NULL', qs_id, cp_id)}
  scope :from_qualification_schema_and_course_period_qualified, -> (qs_id, cp_id) {joins(academic_record: {section: :course_period}).where('qualification_schema_id = ? AND course_periods.id = ? AND value IS NOT NULL', qs_id, cp_id)}

  # ========== qualification_schema_and_section  ===============#
  scope :from_qualification_schema_and_section, -> (qs_id, s_id) {joins(academic_record: :section).where('qualification_schema_id = ? AND sections.id = ?', qs_id, s_id)}
  
  scope :from_qualification_schema_and_section_not_qualified, -> (qs_id, s_id) {joins(academic_record: :section).where('qualification_schema_id = ? AND sections.id = ? AND value IS NULL', qs_id, s_id)}
  
  scope :from_qualification_schema_and_section_qualified, -> (qs_id, s_id) {joins(academic_record: {section: :course_period}).where('qualification_schema_id = ? AND sections.id = ? AND value IS NOT NULL', qs_id, s_id)}

  private

  def set_final
    self.academic_record.update(final_qualification: self.academic_record.calculate_final) 
  end

end
