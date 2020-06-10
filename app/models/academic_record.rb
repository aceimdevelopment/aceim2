class AcademicRecord < ApplicationRecord
  #=========== RELATIONSHIPS=======#
  belongs_to :student, inverse_of: :academic_records
  belongs_to :section, inverse_of: :academic_records
  belongs_to :agreement, inverse_of: :academic_records
  belongs_to :qualification_status, inverse_of: :academic_records
  belongs_to :payment_detail, optional: true, inverse_of: :academic_records

  has_one :course_period, through: :section, dependent: :nullify
  has_one :course, through: :course_period, dependent: :nullify
  has_one :language, through: :course, dependent: :nullify
  has_one :level, through: :course, dependent: :nullify
  has_one :period, through: :course_period, dependent: :nullify

  #============TYPES===============#
  enum inscription_status: [:preinscrito, :confirmado]
  SC = -2
  PI = -1
  #============VALIDATIONS=========#
  validates :student_id, uniqueness: {scope: :section_id}
  after_initialize  :set_default, :if => :new_record?

  #============SCOPE===============#
  scope :approved, -> {where(qualification_status_id: :AP)}
  scope :currents, -> {confirmado.where(qualification_status_id: :SC)}
  scope :from_language, lambda{|language_id| joins(:section).joins(:course_period).joins(:course).where("courses.language_id = ?", language_id).order("created_at DESC")}

  scope :from_period, lambda{|period_id| joins(:section).joins(:course_period).where("course_periods.period_id = ?", period_id)}


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
      field :agreement do
        label 'Convenio'
      end

      field :final_qualification do
        label 'Cal. Final'
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

      field :inscription_status do
        label 'Estado de Inscripción'
      end

      field :final_qualification do
        label 'Final'
      end

    end



    list do
      checkboxes false
      items_per_page 100
      scopes [:preinscrito, :confirmado, nil]

      # field :inscription_status do
      #   label 'Estado'
      #   column_width 60

      # end
      field :final_qualification do
        label 'Final'
        column_width 50
      end
      
      field :student do 
        label 'Estudiante'
      end

      field :period do
        label 'Periodo'
        sortable :name
        filterable :name #[:letter, :year]
        searchable :name #[:letter, :year]
      end

      field :language do
        label 'Idioma'
        sortable :name
        searchable :name
        filterable :name
        column_width 50

      end

      field :level do
        label 'Nivel'
        sortable :grade
        searchable :name
        filterable :name
      end

      field :number do
        label 'Sección'
        formatted_value do
          bindings[:object].section.number
        end

        searchable false
        column_width 80
      end
      field :qualification_status do
        label 'Estado Calific.'
        filterable :name
        searchable :name
        column_width 50
      end
      field :agreement_id do
        label 'Convenio'
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
    aux += " #{period.name}" if periodo
    return aux
  end

  def name
    "#{user_desc}-#{period_desc}-#{section_desc_short}"
  end

  def user_desc
    (student and student.user) ? student.user.description : ""
  end
  def period_desc
    section.period.name if section and section.period
  end

  def section_desc_short
    "#{section.number} (#{section.course.language_id}-#{section.course.level_id})" if section
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

  def set_default
    self.final_qualification ||= SC
    # self.aggrement_id ||= 'REG'
    self.qualification_status_id ||= 'SC'
  end


end
