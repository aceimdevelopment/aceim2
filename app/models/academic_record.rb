class AcademicRecord < ApplicationRecord

  # QUERY CON INCLUDES QUE PUEDE SER UTIL:
  # AcademicRecord.includes({student: :user}, {section: {course_period: [{course: [:language, :level]}, :period]}}).limit(5).each{|ar| ar.student.name; ar.section.name}

  #=========== RELATIONSHIPS=======#
  belongs_to :student, inverse_of: :academic_records
  belongs_to :section, inverse_of: :academic_records
  belongs_to :agreement, inverse_of: :academic_records
  belongs_to :qualification_status, inverse_of: :academic_records
  has_one :payment_detail, inverse_of: :academic_record

  # has_one :carrer, through: :student, dependent: :destroy

  has_one :course_period, through: :section, dependent: :nullify
  has_one :course, through: :course_period, dependent: :nullify
  has_one :language, through: :course, dependent: :nullify
  has_one :level, through: :course, dependent: :nullify
  has_one :period, through: :course_period, dependent: :nullify

  #============TYPES===============#
  enum inscription_status: [:preinscrito, :confirmado, :asignado]
  SC = -2.0
  PI = -1.0
  #============VALIDATIONS=========#
  validates :student_id, uniqueness: {scope: :section_id}
  after_initialize :set_default, :if => :new_record?
  after_save :add_career

  #============SCOPE===============#
  scope :approved, -> {where(qualification_status_id: :AP)}
  scope :not_qualifiqued, -> {where(qualification_status_id: :SC)}
  scope :qualified, -> {where("qualification_status_id != ?", :SC)}
  scope :currents, -> {confirmado.where(qualification_status_id: :SC)}
  scope :from_language, lambda{|language_id| joins(:section).joins(:course_period).joins(:course).where("courses.language_id = ?", language_id).order("created_at DESC")}

  scope :from_period, lambda{|period_id| joins(:section).joins(:course_period).where("course_periods.period_id = ?", period_id)}
  scope :from_periods, -> (period_ids){joins(:section).joins(:course_period).where("course_periods.period_id IN (?)", period_ids)}
  
  scope :from_periods_language, -> (period_ids, language_id){joins(:section).joins(:course_period).joins(:course).where("course_periods.period_id IN (?) AND courses.language_id = ?", period_ids, language_id)}



  scope :from_course_perido, lambda {|course_period_id| joins(:section).joins(:course_period).where("course_periods.id = ?", course_period_id)}

  # ===========RAILS ADMIN ====================#

  rails_admin do

    show do
      field :student do
        label 'Estudiante'
      end

      field :section do
        label 'Sección'

        formatted_value do
          bindings[:object].section.description if bindings[:object].section
        end


        # orderable true
        # N funciona
      end
      field :inscription_status do
        label 'Estado de Inscripción'
      end
      field :agreement do
        label 'Convenio'
      end

      field :final_qualification do
        label 'Cal. Final'
      end

      field :options do
        label 'Opciones'
        formatted_value do
          bindings[:view].render(partial: "send_reconfirmer_button", locals: {object: bindings[:object]})
        end
      end



    end

    edit do
      field :student do
        label 'Estudiante'
      end

      field :section do
        label 'Sección'

        formatted_value do
          bindings[:object].section.description if bindings[:object].section
        end

        # orderable true
        # N funciona
      end

      field :agreement do
        label 'Convenio'
      end

      # field :agreement_id, :enum do
      #   enum do
      #     Agreement.all.map{|inst| [inst.name, inst.id]}
      #   end
      # end


      field :inscription_status do
        label 'Estado de Inscripción'
      end

      field :final_qualification do
        label 'Final'
      end

    end



    list do
      checkboxes false
      items_per_page 60
      # scopes [:preinscrito, :confirmado, nil]

      # field :inscription_status do
      #   label 'Estado'
      #   column_width 60

      # end
      
      field :student do 
        label 'Estudiante'
      end

      field :period do
        label 'Periodo'
        sortable :name
        filterable :name #[:letter, :year]
        searchable :name #[:letter, :year]
        column_width 80
        
      end

      field :language do
        label 'Idioma'
        sortable :name
        searchable :name
        filterable :name
        column_width 80

      end

      field :level do
        label 'Nivel'
        sortable :grade
        searchable :name
        filterable :name
        column_width 80

      end

      field :number do
        label 'Sección'
        formatted_value do
          bindings[:object].section.number
        end

        searchable false
        column_width 80
      end
      field :final_qualification do
        label 'Final'
        column_width 50
      end
      field :inscription_status do
        label 'INS'
        column_width 50
      end
      field :qualification_status do
        label 'Est Cal.'
        filterable :name
        searchable :name
        column_width 50
      end
      field :agreement_id do
        label 'Conv'
        column_width 50
      end
      # fields :student, :period, :language, :level, :section, :agreement_id, :qualification_status, :final_qualification
    end
  end

  # ===========RAILS ADMIN END ================#



  #============FUNCTIONS============#
  # def language
  #   course.language.name if course
  # end

  # def level
  #   course.level.name if course
  # end

  def online?
    self.course_period.online?
  end

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

  def desc_to_pay
    aux = ""
    aux += "(#{student.personal_identity_document})" if student
    aux += " #{section.number}" if section
    aux += " #{course.language.name} #{course.level.name}" if course
    aux += " #{period.name}" if period
    return aux
  end

  def name
    "#{user_desc} en #{self.section.desc_short if self.section}"
  end

  def user_desc
    (student and student.user) ? student.name : ""
  end
  def period_desc
    section.period.name if section and section.period
  end

  def section_desc_short
    # "#{section.course.language_id} | #{section.course.level_id} | #{section.course_period.kind[0..3]}" if section and section.course_period
    self.section.desc_short
  end

  def SC?
    self.final_qualification.eql? SC
  end

  def final_desc
    case final_qualification
      when SC 
         "SC"
      when PI
        "PI"
      else
        sprintf("%02i",final_qualification)
    end
  end

  protected

  def add_career
    unless Career.where(student_id: self.student_id, language_id: self.language.id).any?
      Career.create(student_id: self.student_id, language_id: self.language.id)
    end
  end


  def set_default
    self.final_qualification ||= SC
    self.agreement_id ||= 'REG'
    self.qualification_status_id ||= 'SC'
  end


end
