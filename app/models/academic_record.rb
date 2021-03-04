class AcademicRecord < ApplicationRecord

  # QUERY CON INCLUDES QUE PUEDE SER UTIL:
  # AcademicRecord.includes({student: :user}, {section: {course_period: [{course: [:language, :level]}, :period]}}).limit(5).each{|ar| ar.student.name; ar.section.name}

  #=========== PAPER TRAIL ========#
  has_paper_trail

  #=========== RELATIONSHIPS=======#
  belongs_to :student, inverse_of: :academic_records
  belongs_to :section, inverse_of: :academic_records
  belongs_to :agreement, inverse_of: :academic_records
  belongs_to :qualification_status, inverse_of: :academic_records
  has_one :payment_detail, inverse_of: :academic_record

  has_many :partial_qualifications, inverse_of: :academic_record

  # has_one :carrer, through: :student, dependent: :destroy

  has_one :course_period, through: :section, dependent: :nullify
  has_one :course, through: :course_period, dependent: :nullify
  has_one :language, through: :course, dependent: :nullify
  has_one :level, through: :course, dependent: :nullify
  has_one :period, through: :course_period, dependent: :nullify
  has_one :user, through: :student#, dependent: :nullify

  #============TYPES===============#
  enum inscription_status: [:preinscrito, :confirmado, :asignado]
  SC = -2.0
  PI = -1.0
  #============VALIDATIONS=========#
  validates :student_id, uniqueness: {scope: :section_id}

  # validates :student_id, uniqueness: {scope: from_course_perido()}
  validates_with StudentCoursePeriod, field_name: false, if: :new_record?

  after_initialize :set_default, :if => :new_record?
  after_save :add_career
  after_destroy :destroy_career

  #============SCOPE===============#
  # scope :not_preinscrito, -> {where('inscription_status != 0')}
  # OJO: El scope anterior ya está por defecto para los enum ej: not_
  scope :approved, -> {where(qualification_status_id: :AP)}
  scope :repproved, -> {where("qualification_status_id = 'RE'")}
  scope :pi, -> {where("qualification_status_id = 'PI'")}
  scope :not_qualifiqued, -> {where(qualification_status_id: :SC)}

  scope :not_canvas_registers, -> {joins(:user).where('users.canvas_status != 2')}

  scope :reported, -> {joins(:payment_detail)}
  scope :total_reported, -> {reported.count}
  scope :total_preenrollment_unreported, -> {preinscrito.count - total_reported}

  scope :qualified, -> {where("qualification_status_id != ?", :SC)}
  scope :currents, -> {confirmado.where(qualification_status_id: :SC)}
  scope :from_language, lambda{|language_id| joins(:section).joins(:course_period).joins(:course).where("courses.language_id = ?", language_id).order("created_at DESC")}

  scope :from_period, -> (period_id) {joins(:section).joins(:course_period).where("course_periods.period_id = ?", period_id)}
  scope :from_periods, -> (period_ids) {joins(:section).joins(:course_period).where("course_periods.period_id IN (?)", period_ids)}
  scope :from_periods_language, -> (period_ids, language_id){joins(:section).joins(:course_period).joins(:course).where("course_periods.period_id IN (?) AND courses.language_id = ?", period_ids, language_id)}
  scope :from_course_perido, -> (course_period_id) {joins(:section).joins(:course_period).where("course_periods.id = ?", course_period_id)}

  scope :todos, -> {where('0 = 0')}

  scope :academic_record_search, -> (keyword) {joins({student: :user}, {section: {course_period: [{course: [:language, :level]}, :period]}}).where("students.personal_identity_document LIKE ? or users.name LIKE ? or users.email LIKE ? or users.last_name LIKE ? or periods.name LIKE ? or languages.name LIKE ? or levels.name LIKE ?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "#{keyword}")}

  # =========== CALLBACKS ====================#

  before_update :set_qualification_status, :if => :final_qualification_changed?

  # ===========RAILS ADMIN ====================#

  def have_report
    !self.payment_detail.nil?
  end

  rails_admin do

    export do

      field :period do
        label 'Periodo'
      end

      field :course_period do
        label 'Programación'
      end

      field :language do
        label 'Idioma'
      end

      field :level do
        label 'Nivel'
      end

      field :export_section do
        label 'Sección'
      end

      field :student do
        label 'Estudiante'
      end

      field :user do
        label 'Usuario'
      end

      field :export_agreement do
        label 'Convenio'
      end

      field :inscription_status do
        label 'Estado'
      end

      field :final_desc do
        label 'Final'
      end

    end

    show do
      field :student do
        label 'Estudiante'
      end

      field :desc_show do
        label 'Sección'
        formatted_value do
          bindings[:view].render(partial: 'sections/description_table', locals: {section: bindings[:object].section})
        end
      end

      field :inscription_status do
        label 'Estado de Inscripción'
      end

      field :quickview_payment_detail do 
        label 'Reporte de Pago'
        formatted_value do
          bindings[:view].render(partial: '/payment_details/quick_report', locals: {academic_record: bindings[:object]})
        end
      end
      field :agreement do
        label 'Convenio'
      end

      field :final_qualification do
        label 'Cal. Final'
      end

      field :q_detail_table do
        label 'Calificaciones Parciales'
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
          bindings[:object].section.name if bindings[:object].section
        end

      end

      # field :section do
      #   label 'Sección'

      #   formatted_value do
      #     bindings[:object].section.description if bindings[:object].section
      #   end
      # end

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
      scopes [:todos, :preinscrito, :confirmado, :asignado]
      filters [:period, :language, :level]
      search_by :academic_record_search
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
        label 'Sec #'
        formatted_value do
          bindings[:object].section.number
        end

        searchable false
      end

      field :canvas_course_id do
        label 'Id Curso Canvas'
        formatted_value do
          bindings[:view].content_tag(:a, bindings[:object].section.id_canvas, {href: bindings[:object].section.full_url_canvas_section, target: '_blank'})
        end
        column_width 80

      end

      field :user_canvas_status do
        label 'Estado Usuario Canvas'
        formatted_value do
          bindings[:view].render(partial: 'users/canvas_status', locals: {ar: bindings[:object]})
        end
        column_width 100
        # filterable 'user[canvas_status]'
        # filterable 'student.user.canvas_status'


      end

      field :label_status_enroll do
        label 'Estado Insc.'
        formatted_value do
          bindings[:view].render(partial: 'academic_records/label_status', locals: {ar: bindings[:object]})
        end
        column_width 100

      end

      field :qualification_status do
        label 'Estado Calif.'
        column_width 100
      end
      
      field :final_qualification do
        label 'Final'
      end

      field :agreement_id do
        label 'Conv'
        column_width 50
      end

      field :payment_detail do
        label 'Reporte Pago'
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

  def class_approved
    (final_desc and final_desc.to_i > 14) ? 'alert-success' : 'alert-danger'
  end

  def ci
    student.ci
  end

  def career
    Career.where(student_id: self.student_id, language_id: self.language.id).first
  end

  def approved?
    self.qualification_status_id.eql? 'AP'
  end


  def qualification_status_style

    if repproved?
      aux = 'danger' 
    elsif qualification_status_id.eql? 'AP'
      aux = 'success'
    else
      aux = 'info'
    end
    return aux
  end

  def repproved?
    self.qualification_status_id.eql? 'PI' or qualification_status_id.eql? 'RE'
  end

  def is_last_level_approved?
    last_approved = career.last_level_approved
    last_approved and self.level.id.eql?(last_approved.level.id)
  end

  def user
    student.user
  end

  def export_agreement
    agreement.name if agreement
  end

  def export_language
    language.name if language
  end

  def export_level
    level.name if level
  end

  def export_kind
    course_period.kind if course_period
  end


  def export_section
    section.number_to_string if section
  end

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
    self.qualification_status_id.eql? 'SC'
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

  def calculate_final
    final = 0
    self.partial_qualifications.where('value IS NOT NULL').each do |pq|
      percent = pq.qualification_schema ? pq.qualification_schema.percentage*(0.01) : 0
      final += percent*pq.value
    end
    return final.round
  end

  def q_detail_table
    if partial_qualifications.any?
      aux = "<table class='table'><thead><tr>"
      partial_qualifications.each do |par|
        aux += "<th class='text-center'>#{par.qualification_schema.desc}</th>"
      end
      aux += "</tr></thead><tbody><tr>"
      partial_qualifications.each do |par|
        aux += "<td class='text-center'>#{par.value}</td>"
      end
      aux += "</tr></tbody></table>"
      aux.html_safe
    else
      ""
    end
  end

  def label_fq
    if qualification_status_id.eql? 'PI' or qualification_status_id.eql? 'RE'
      aux = 'danger' 
    elsif qualification_status_id.eql? 'AP'
      aux = 'success'
    else
      aux = 'info'
    end
    "<span class='label label-#{aux}'>#{qualification_status.name}</span>"
  end

  def label_insc_status(view=nil)
    if asignado? 
      aux = 'success' 
    elsif confirmado?
      aux = 'warning'
    else
      aux = 'info'
    end

    label = (view and view.eql? 'admin') ? 'label' : 'badge'

    "<span class='#{label} #{label}-#{aux}'>#{inscription_status}</span>"
  end

  def build_qualification_status_id
    # aux = calculate_final
    aux = self.final_qualification
    aux_approved = 'SC'
    if aux.eql? PI
      aux_approved = 'PI'
    elsif aux >= 15
      aux_approved = 'AP'
    elsif aux > 0 and aux < 15
      aux_approved = 'RE'
    end
    return aux_approved
  end

  def check_canvas_enrollment
    begin
      emails = self.course_period.canvas_email_list
      self.update(inscription_status: :asignado) if (emails.any? and (emails.include? self.user.email))
    rescue Exception => e
      e
    end
  end

  protected

  def set_qualification_status
    self.qualification_status_id = build_qualification_status_id
    # if partial_qualifications.where('value IS NULL').count == 0
    # else
    #   self.qualification_status_id = 'SC'
    # end
  end

  # OJO: ¡¡¡ATENCIÓN!!! AL INTENTAR REALIZAR LA ACCIÓN DEBAJO SE GENERA UN ABRAZO MORTAL, YA QUE SE ACTUALIZAN PARCIALES Y SE VUELVE A ACTUALIZAR FINAL. SOLUCIÓN: AGREGAR EN LA EDICIÓN DE ACADEMIC RECORD SOLO CALIFICACIONES PARCIALES Y NO FINAL
  def set_partials_qualifications
    self.partial_qualifications.each{|partial| partial.update(value: final_qualification.to_i)}
  end

  def destroy_career
    career.destroy unless career.academic_records.any?
  end

  def add_career
    Career.create(student_id: self.student_id, language_id: self.language.id) if self.career.nil?
  end


  def set_default
    self.final_qualification ||= SC
    self.agreement_id ||= 'REG'
    self.qualification_status_id ||= 'SC'
  end


end
