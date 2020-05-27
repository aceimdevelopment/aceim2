class AcademicRecord < ApplicationRecord
  belongs_to :student
  belongs_to :section
  belongs_to :agreement
  belongs_to :qualification_status
  belongs_to :payment_detail, optional: true

  enum inscription_status: [:Preinscrito, :Confirmado]

  def before_import_save(record)
    if (letter_aux, year_aux = record[:period_id].split("-")) && (period_aux = Period.where(year: year_aux, letter: letter_aux).first) && (course_aux = Course.where(language_id: record[:language_id], level_id: record[:level_id]).first) && (course_period_aux = CoursePeriod.where(period_id: period_aux.id, course_id: course_aux.id).first) && (section_aux = Section.where(course_period_id: course_period_aux.id, number: record[:number]).first)
      self.section_id = section_aux.id
    end

    if (email = record[:user_email]) && (user_aux = User.find_by_email(email))
      self.student_id = user_aux.id
    end
    self.agreement_id = record[:agreement_id]
    self.inscription_status = :Confirmado
    self.qualification_status_id = record[:qualification_status_id]
    self.final_qualification = record[:final_qualification]
  end

  def name
    "#{user_desc}-#{period_desc}-#{section_desc_short}"
  end

  def user_desc
    (student and student.user) ? student.user.description : ""
  end
  def period_desc
    section.period.name
  end

  def section_desc_short
    "#{section.number} (#{section.course.language_id}-#{section.course.level_id})"
  end

end
