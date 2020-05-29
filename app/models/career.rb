class Career < ApplicationRecord
  belongs_to :agreement
  belongs_to :language
  belongs_to :student

  validates :agreement_id, presence: true
  validates :language_id, presence: true
  validates :student_id, presence: true


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
