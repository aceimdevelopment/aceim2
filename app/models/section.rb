class Section < ApplicationRecord
  
  # ========== RELATIONSCHIPS ============ #

  belongs_to :course_period, inverse_of: :sections
  # accepts_nested_attributes_for :course_period
  belongs_to :instructor, foreign_key: :instructor_id, primary_key: :user_id, optional: true, inverse_of: :sections
  # accepts_nested_attributes_for :instructor
  
  # belongs_to :evaluator, class_name: 'Instructor', foreign_key: :evaluator_id, primary_key: :user_id, optional: true, inverse_of: :sections
  # accepts_nested_attributes_for :evaluator

  has_one :qualification_detail, inverse_of: :section
  # accepts_nested_attributes_for :qualification_datail

  has_one :period, through: :course_period
  has_one :course, through: :course_period
  has_one :language, through: :course
  has_one :level, through: :course

  has_many :academic_records, inverse_of: :section
  accepts_nested_attributes_for :academic_records

  # ========== VALIDATIONS ============ #
  
  validates :number, presence: true
  validates :course_period_id, presence: true
  # validates :instructor_id, presence: true

  validates :number, uniqueness: { scope: :course_period_id }

  before_save :set_name

  # validates_uniqueness_of :horario_id, scope: [:dia, :entrada], message: 'Ya existe un horario con una hora de entrada igual para la sección.', field_name: false

  # validates_uniqueness_of :number, scope: [:course_period_id], message: 'La sección ya existe para el período seleccionado', field_name: false, case_sensitive: true

  # ========== SCOPE ============ #
  scope :section_search, -> (keyword) {where("sections.name LIKE ?", "%#{keyword}%")}

  # ========== RAILS ADMIN ============ #

  rails_admin do

    show do

      field :desc_show do
        label 'Descripción'
        formatted_value do
          bindings[:view].render(partial: 'sections/description_table', locals: {section: bindings[:object]})
        end

      end
      field :emails do
        label 'Emails'
        formatted_value do
          bindings[:view].render(partial: "sections/emails_section", locals: {section: self.bindings[:object]})
        end
      end

      field :records do
        label 'Inscripciones'
        formatted_value do
          bindings[:view].render(partial: "table_academic_records_partial", locals: {section: self.bindings[:object]})
        end
      end
    end

    update do
      field :description do
        label 'Descripción'
        read_only true
      end
      field :number do
        label 'número'
      end      
      field :open do
        label '¿Abierta?'
      end

      field :id_canvas

      field :url_classroom_canvas do
        label 'Url de Aula en Canvas'
      end
      field :instructor_id, :enum do
        enum do
          Instructor.all.map{|inst| [inst.name, inst.id]}
        end
      end

    end

    # OJO éste es el caso para NEW_RECORDS (new)! 
    edit do
      field :course_period do
        label 'Curso Periodo'
        inline_edit false
        inline_add false
        queryable "course_periods_periods.name"
      end
      # field :course_period_id, :enum do
      #   enum do
      #     course_periods_aux = bindings[:object].period ? bindings[:object].period.course_periods : CoursePeriod.all
      #     course_periods_aux.map{|cp| [cp.name, cp.id]}
      #   end
      # end

      field :number do
        label 'número'
      end
      field :instructor_id, :enum do
        enum do
          Instructor.all.map{|inst| [inst.name, inst.id]}
        end
      end
      field :id_canvas

      field :url_classroom_canvas do
        label 'Url Automatricula Canvas'
      end

      field :open do
        label '¿Abierta?'
      end
    end

    list do
      search_by :section_search
      # items_per_page 10
      filters [:period, :language, :level]

      field :period do
        label 'Periodo'

        formatted_value do
          bindings[:object].period.name
        end
        queryable true
        sortable true
        searchable :name
        filterable :name
      end




      # field :period, :enum do
      #   label 'Periodo'
      #   enum do
      #     Period.all.collect {|p| [[p, p.id]]}
      #   end
      #   # pretty_value do
      #   #   value.try(:period)
      #   # end
      #   formatted_value do
      #     bindings[:object].period
      #   end
      #   # sortable :name
      #   filterable true
      #   # searchable :nema
      # end



      field :language do
        label 'Idioma'
        # enum do
        #   Language.all.map{|p| [p.name, p.id]}
        # end
        formatted_value do
          bindings[:object].language.name
        end
        queryable true
        sortable :name
        filterable :name
        searchable :name
      end

      field :level do
        label 'Nivel'
        formatted_value{ bindings[:object].level.name }
        queryable true
        sortable :grade
        filterable :name
        searchable :name
      end
      field :number_to_string do
        label 'número'
        filterable false
      end

      field :kind do 
        label 'Tipo'
        formatted_value{ bindings[:object].course_period.kind}
        # queryable "course_periods.kind"
        sortable "course_periods.kind"
        filterable "course_periods.kind"
        searchable "course_periods.kind"
      end
      # field :kind, :enum do
      #   label 'Tipo'
      #   enum do
      #     CoursePeriod::kinds
      #   end

      #   # queryable true
      #   sortable "course_periods.kind" #CoursePeriod::kinds.keys
      #   filterable "course_periods.kind"
      #   searchable false
      # end

      field :instructor do
        label 'Instructor'
      end

      field :open do
        label '¿Abierta?'
      end      
      field :registed do
        label 'PRE'
      end
      field :enrolled do
        label 'CONF'
      end

      field :asigned do
        label 'ASIG'
      end

      field :id_canvas

      field :aula do
        label 'Url Automatricula Canvas'
        formatted_value{ bindings[:object].url_classroom_canvas.split("/").last if bindings[:object].url_classroom_canvas }
      end
    end
  end

  # ========== FUNCTIONS ============ #
  def list_of_emails_canvas
    academic_records.reject{|ar| ar.user.id_canvas}.map{|ar| ar.user.name_for_email_canvas}.join(", ")
  end


  def create_section_on_canvas (canvas_connection = MyCanvas.connect)
    section_canvas = canvas_connection.post("/api/v1/courses/#{self.course_period.id_canvas}/sections", {'course_section' => {'name' => "#{title_for_create_canvas}"}})

    self.update(id_canvas: section_canvas['id']) if section_canvas
  end

  def destroy_section_on_canvas (canvas_connection = MyCanvas.connect)

    errors = []
    unenrolled = 0
    section_deleted = false

    section0 = self.course_period.sections.where(number: 0).first
    section0 ||= self.course_period.sections.create(number: 0)

    inscritos_en_canvas = canvas_connection.get("/api/v1/sections/#{self.id_canvas}/enrollments", {per_page: 40})
      inscritos_en_canvas.each do |ele|
        begin
          unenrolled += 1 if canvas_connection.delete("/api/v1/courses/#{self.course_period.id_canvas}/enrollments/#{ele['id']}", {task: :delete})
    
        rescue Exception => e
          errors << e
        end
      end

    if (inscritos_en_canvas.count.eql? unenrolled) and canvas_connection.delete("/api/v1/sections/#{self.id_canvas}")
      section_deleted = true 
      self.academic_records.not_preinscrito.update_all(inscription_status: :confirmado, section_id: section0.id)
      self.destroy
    end
    return [errors, unenrolled, section_deleted]

  end

  def enrollments_to_canvas(canvas_connection = MyCanvas.connect)
    total_enrolled = 0
    academic_records.confirmado.each do |ar|
      if ar.user.id_canvas
        new_enrolled_canvas = canvas_connection.post("/api/v1/sections/#{self.id_canvas}/enrollments", {'enrollment' => {'user_id' => ar.user.id_canvas, 'type' => 'StudentEnrollment', 'limit_privileges_to_course_section' => true, 'notify' => true, 'enrollment_state' => 'active'}})
         total_enrolled += 1 if (new_enrolled_canvas and ar.update(inscription_status: :asignado))
      end
    end
    return total_enrolled
  end

  def number_to_string
    sprintf("%02i",self.number)
  end

  def registed
    academic_records.preinscrito.count
  end

  def enrolled
    academic_records.confirmado.count
  end

  def asigned
    academic_records.asignado.count
  end

  def canvas
    academic_records.asignado.count
  end

  def course_period_kind
    course_period.kind if course_period
  end


  def before_import_save(record)
    if (letter_aux, year_aux = record[:period_id].split("-")) && (period_aux = Period.where(year: year_aux, letter: letter_aux).first) &&
      (course_aux = Course.where(language_id: record[:language_id], level_id: record[:level_id]).first)
      course_period_aux = CoursePeriod.where(period_id: period_aux.id, course_id: course_aux.id).first
      self.course_period_id = course_period_aux.id
    end

    if (email = record[:instructor_email]) && (user_aux = User.find_by_email(email))
      self.instructor_id = user_aux.id
    end
    if (email = record[:evaluator_email]) && (user_aux = User.find_by_email(email))
      self.evaluator_id = user_aux.id
    end

  end

  def full_url_canvas_section
    if (course_period.id_canvas and id_canvas)
      "https://canvas.instructure.com/courses/#{course_period.id_canvas}/sections/#{id_canvas}"
    else
      "#"
    end
  end

  def desc_work_proof
    self.course_period.desc_work_proof
  end

  def description
    self.course_period ? "#{number}|#{course_period.name}" : self.id.to_s
  end
  def desc_short
    self.course_period ? "#{course_period.desc_short} #{number}" : self.id.to_s
  end

  def name_canvas
    if course_period and course and number and course_period.kind
      "#{course.language_id}-#{course.level_id}-#{number_to_string}-#{course_period.kind[0]}"
    else
      id
    end
  end

  def title_for_create_canvas
    if course_period and course and number and course_period.kind
      "#{course.language_id} - #{course.level.name} #{course_period.kind.upcase} - #{number_to_string}"
    else
      id
    end

  end

  # def name
  #   # if controller_name.eql? 'academic_record' and action_name.eql? 'new'
  #   # else
  #   #   self.number
  #   # end
  #   self.course_period ? "#{course_period.name} #{number}" : number
  # end

  protected

  def set_name
    self.name = "#{course_period.name} #{number_to_string}" if course_period
  end
end
