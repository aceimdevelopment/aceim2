class Career < ApplicationRecord

  # =============== ASSOTIACIONS =================#
  belongs_to :agreement, inverse_of: :careers
  belongs_to :language, inverse_of: :careers
  belongs_to :student, inverse_of: :careers
  belongs_to :leveling_period, foreign_key: :leveling_period_id, class_name: 'Period', optional: true#, inverse_of: :carrers
  
  has_one :user, through: :student

  # has_many :academic_records, through: :student 

  # =============== VALIATIONS =================#
  validates :agreement_id, presence: true
  validates :language_id, presence: true
  validates :student_id, presence: true

  
  # =============== SCOPES =================#

  scope :leveled, -> {where('leveling IS NOT NULL')}
  scope :not_leveled, -> {where('leveling IS NULL')}

  # =============== FUNCTIONS =================#
  # def academic_records
  #   self.student.academic_records.joins(:level).order('levels.grade desc').from_language(language_id)
  # end

  def enrollment_leveling
    academic_records.where("levels.id = 'NIVE'")
  end


  def academic_records
    # self.student.academic_records.joins(:level).order('levels.grade desc').from_language(language_id)
    self.student.academic_records.joins({section: {course_period: [{course: :level}, :period]}}).order(['periods.year': :desc, 'periods.letter': :desc, 'levels.grade': :desc]).from_language(language_id)
  end

  def academic_record_approved
    academic_records.approved
  end

  def total_academic_hours_approved
    aux = 0
    academic_records.approved.map{|ar| aux += ar.period.academic_hours}
    return aux
  end

  def total_hours_career
    hours_period = self.last_academic_record.period.academic_hours
    total_level_language = self.language.total_levels
    hours_period.to_i*total_level_language.to_i
  end

  def finished?
    final_level = language.last_level

    last_level_approved and (final_level.eql? last_level_approved.course.grade)
  end

  def last_academic_record
    self.academic_records.first
  end

  def last_level_approved #alias last_academic_record_approved
    self.last_academic_record_approved
  end

  def last_academic_record_approved
    self.academic_records.approved.first
  end

  #====== LA IDEA ES QUE NO SE LE OFERTE PARA PREINSCRIBIR UN CURSO QUE YA TIENE PREINSCRITO O APROBADO ======#
  def last_course_enrollment
    aux = academic_records.preinscrito.last
    return aux ? aux.course : nil
  end

  def next_course_available
    course = self.language.first_course
    approved = self.last_academic_record_approved
    msg = ""
    if approved
      distance = Period.distance_between_active_enrollment_period approved.period
      
      if distance
        if (distance.eql? 0 or distance.eql? 1 or distance.eql? 2)
          course = approved.course.next_course 
        elsif (distance.eql? 3)
          course = approved.course 
          msg = "Usted a pasado 2 períodos sin aprobar su curso. Deberá tomar nuevamente su último nivel aprobado #{course.name}"
        elsif (distance > 3)
          msg = 'Usted a pasado más de 2 períodos sin aprobar un curso. Debe tomar la prueba de nivelación o comenzar  desde el primer nivel'
        end
      end
    elsif last_record = self.academic_records.last
      distance = Period.distance_between_active_enrollment_period last_record.period
      if distance and distance < 3
        course = last_record.course 
      else
        msg = 'Usted a pasado más de 2 períodos sin aprobar un curso. Debe tomar la prueba de nivelación o comenzar desde el primer nivel'
      end
    end
    [course, msg]
  end
  #=================================================================#

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
