class CoursePeriod < ApplicationRecord
  #========== ASSOCIATIONS ==========#
  
  belongs_to :course, inverse_of: :course_periods
  belongs_to :period, inverse_of: :course_periods
  # has_one :language, through: :course, dependent: :nullify
  has_many :sections, inverse_of: :course_period
  accepts_nested_attributes_for :sections

  has_many :academic_records, through: :sections, inverse_of: :course_period
  accepts_nested_attributes_for :academic_records

  # has_one :language, through: :course
  # accepts_nested_attributes_for :language

  # has_one :level, through: :course
  # accepts_nested_attributes_for :level

  #========== VALIDATIONS ==========#
  validates :course, presence: true
  validates_with StudentCoursePeriod, field_name: false, if: :new_record?
  validates :period, presence: true
  validates :kind, presence: true
  validates :capacity, presence: true
  enum kind: [:online, :interdiario, :sabatino, :mixtos]

  after_create :create_first_section
  #========== SCOPE ==================#

  scope :from_period, -> (period_id) {where(period_id: period_id)}
  scope :from_language, -> (language_id) {joins(:course).where("courses.language_id = ?", language_id)}

  # scope :approved, -> {where(qualification_status_id: :AP)}
  #========== RAILS ADMIN ============= #


  rails_admin do

    # import do
    #   mapping_key = [:period_id, :language_id, :level_id]
    #   mapping_key_list [:period_id, :language_id, :level_id]
    # end

    show do
      field :course do
        label 'Curso'
      end
      field :period do
        label 'Period'
      end
      field :kind do
        label 'Tipo'
      end
      field :capacity do
        label 'Capacidad del Curso'
      end      
      field :sections do
        label 'Secciones'
      end

      field :canvas_enrollemnets do
        label 'Inscritos en Canvas'
        formatted_value do
          bindings[:view].render(partial: 'academic_records/canvas_enrollments_index', locals: {course_period: bindings[:object]})
        end
      end
    end

    list do

      field :period do
        label 'Periodo'
        formatted_value do
          bindings[:object].period.name
        end
        filterable true
        searchable true
      end

      field :language do
        label 'Idioma'
        formatted_value do
          bindings[:object].course.language.name
        end
        filterable :name
        searchable false #:name
      end

      field :level do
        label 'Nivel'
        formatted_value do
          bindings[:object].course.level.name
        end
        filterable false #:name
        searchable false #:name
      end

      field :capacity do
        label 'Capacidad'
      end

      field :enrollments_confirmed do
        label 'Ins/Confir/RegCanvas'
      end

      field :enrolled do
        label 'PRE'
      end

      field :confirmed do
        label 'CONF'
      end

      field :reg_canvas do
        label 'CANVAS'
      end

      # field :course do
      #   label 'curso'
      # end
      # field :period do
      #   label 'periodo'
      #   filterable :name
      #   searchable :name
      # end
      field :kind do
        label 'tipo'
      end
      field :numbers do
        label 'secciones'
        formatted_value do
          bindings[:object].sections.map { |s| s.number_to_string }.to_sentence
        end
      end

      field :id_canvas do
        label 'Canvas'
      end

    end

    edit do
      field :course do
        label 'curso'
      end
      field :period do
        label 'periodo'
      end

      field :capacity do
        label 'Capacidad'
      end

      field :kind do
        label 'Tipo'
      end
      field :id_canvas do
        label 'Identificador Canvas'
        html_attributes do
          {:onInput => "$(this).val($(this).val().toUpperCase().replace(/[^0-9|]/g,''))"}
        end
      end

    end

  end
  

  #========== FUNCTIONS =============#
  def canvas_email_list
    emails = []
    if self.id_canvas
      canvas = MyCanvas.connect
      enrollments_canvas = canvas.get("/api/v1/courses/#{self.id_canvas}/enrollments", {per_page: 200, role: "StudentEnrollment"})
      emails_list = enrollments_canvas.map{|ele| ele['user']['login_id']}
    end
    emails_list
  end


  # def canvas_get_course
  #   if id_canvas
  #     canvas = MyCanvas.connect
  #     cp = canvas.get("/api/v1/courses/#{self.id_canvas}")
  #     # OJO: A priori no se conoce la seccion
  #   else
  #     return '--'
  #   end

  # end

  def enrollments_confirmed
    "#{academic_records.preinscrito.count}/#{academic_records.confirmado.count}/#{academic_records.asignado.count}"
  end

  def enrolled
    academic_records.preinscrito.count
  end

  def confirmed
    academic_records.confirmado.count
  end

  def reg_canvas
    academic_records.asignado.count
  end

  def next_section_number
    self.sections.map{|s| s.number}.max.to_i+1
  end

  def language
    course.language if course
  end

  def level
    course.level if course
  end

  def before_import_save(record)
    if (letter_aux, year_aux = record[:period_id].split("-")) && (period = Period.where(year: year_aux, letter: letter_aux).first)
      self.period_id = period.id
    end
    if (course = Course.where(language_id: record[:language_id], level_id: record[:level_id]).first)
      self.course_id = course.id
    end
    self.kind = :Mixtos
  end

  def description_inscription
    "#{course.name} para el período #{period.name} en la modalidad #{kind.capitalize}"
  end

  def name
    (self.period and self.course) ? "#{self.period.name}|#{self.course.name}|#{self.kind}" : "#{self.id}"
  end

  def desc_short
    "#{self.period.name} #{self.course.language_id} #{self.course.level_id} #{self.kind[0..2].upcase}"
  end

  protected

  def create_first_section
    sections.create(number: '1') unless sections.any?
  end

end
