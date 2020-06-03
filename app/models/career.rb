class Career < ApplicationRecord
  belongs_to :agreement
  belongs_to :language
  belongs_to :student

  validates :agreement_id, presence: true
  validates :language_id, presence: true
  validates :student_id, presence: true

  def academic_records
    student.academic_records.from_language(language_id)
  end

  def last_academic_record
    academic_records.first
  end

  def last_academic_record_approved
    academic_records.approved.first
  end

  #====== LA IDEA ES QUE NO SE LE OFERTE PARA PREINSCRIBIR UN CURSO QUE YA TIENE PREINSCRITO O APROBADO   ======#
  def last_course_enrollment
    aux = academic_records.preinscrito.last
    return aux ? aux.course : nil
  end
  def next_course_available
    approved = last_academic_record_approved
    course = approved.course
    course.next_course
  end
  #=================================================================#

  def next_course
    approved = last_academic_record_approved
    course = approved.course
    course.next_course
  end


  def before_import_save(record)
    if (email = record[:user_email]) && (user_aux = User.find_by_email(email))
      self.student_id = user_aux.id
    end
    self.language_id = record[:language_id]
    self.agreement_id = record[:agreement_id]
  end

  def name
  	aux = ""
  	aux += "#{student.user.name}" if student and student.user
  	aux += " - #{language.name}" if language
  	aux += " - #{agreement.name}" if agreement
  	return aux
  end

end
