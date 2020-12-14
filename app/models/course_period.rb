class CoursePeriod < ApplicationRecord
  #========== ASSOCIATIONS ==========#
  
  belongs_to :course, inverse_of: :course_periods
  belongs_to :period, inverse_of: :course_periods
  # has_one :language, through: :course, dependent: :nullify
  has_many :sections, inverse_of: :course_period
  accepts_nested_attributes_for :sections

  has_many :academic_records, through: :sections, inverse_of: :course_period
  accepts_nested_attributes_for :academic_records

  has_one :language, through: :course
  # accepts_nested_attributes_for :language

  has_one :level, through: :course
  # accepts_nested_attributes_for :level

  #========== VALIDATIONS ==========#
  validates :course, presence: true
  validates :period, presence: true
  validates :kind, presence: true
  validates :capacity, presence: true
  enum kind: [:online, :interdiario, :sabatino, :mixtos]

  after_create :create_first_section
  #========== SCOPE ==================#

  scope :from_period, -> (period_id) {where(period_id: period_id)}
  scope :from_language, -> (language_id) {joins(:course).where("courses.language_id = ?", language_id)}

  scope :my_custom_search, -> (keyword) {joins({course: [:language, :level]}, :period).where("periods.name LIKE ? or languages.name LIKE ? or levels.name LIKE ?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%")}


  # scope :approved, -> {where(qualification_status_id: :AP)}
  #========== RAILS ADMIN ============= #


  rails_admin do

    # import do
    #   mapping_key = [:period_id, :language_id, :level_id]
    #   mapping_key_list [:period_id, :language_id, :level_id]
    # end

    export do
      field :kind do
        label 'Tipo'
      end
      field :period do 
        label 'Periodo'
      end
      field :id_canvas
      field :capacity do
        label 'Capacidad'
      end
    end

    show do
      # field :id_canvas do 
      #   label 'Id Canvas'
      #   formatted_value do
      #     path = "https://canvas.instructure.com/courses/#{bindings[:object].id_canvas}/settings"
      #     bindings[:view].link_to(bindings[:object].id_canvas, path, {target: '_blank'} )
      #   end
      # end

      field :desc_show do
        label 'Descripción'
        formatted_value do
          bindings[:view].render(partial: 'course_periods/desc_show', locals: {cp: bindings[:object]})
        end

      end
      field :resumen_sections do
        label 'Secciones'
        formatted_value do
          bindings[:view].render(partial: 'course_periods/sections_index', locals: {course_period: bindings[:object]})
        end
      end

      # field :canvas_enrollemnets do
      #   label 'Inscritos en Canvas'
      #   formatted_value do
      #     bindings[:view].render(partial: 'academic_records/canvas_enrollments_index', locals: {course_period: bindings[:object]})
      #   end
      # end
    end

    list do
      # sort_by 'periods.created_at DESC'
      search_by :my_custom_search
      checkboxes false
      items_per_page 33
      filters [:period, :language, :level]

      field :period do
        label 'Periodo'
        formatted_value do
          bindings[:object].period.name
        end
        searchable :name
        filterable :name
        sortable 'periods.name'
      end

      field :language do
        label 'Idioma'
        searchable :name
        filterable :name
        sortable 'languages.id'

        formatted_value do
          bindings[:object].course.language.name
        end
        # queryable true
        # sortable true
        # searchable 'course_periods.courses.languages.name'
        # filterable 'course_periods.courses.languages.name'
      end

      field :level do
        label 'Nivel'
        searchable :name
        filterable :name
        sortable 'levels.grade'
        formatted_value do
          bindings[:object].course.level.name
        end
      end

      field :capacity do
        searchable false
        label 'Capacidad'
      end

      field :enrolled do
        label 'PRE'
        sortable true
      end

      field :confirmed do
        label 'CONF'
        sortable true
      end

      field :reg_canvas do
        label 'CANVAS'
        sortable true
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
        sortable true
      end
      field :numbers do
        label 'secciones'
        formatted_value do
          #bindings[:object].sections.map{ |s| bindings[:view].link_to(s.number_to_string, "/admin/section/#{s.id}") }.to_sentence
          bindings[:object].sections.map{ |s| s.number_to_string }.to_sentence

        end
      end

      field :id_canvas do
        searchable false

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

  def canvas_format_response(list, type)
      tipo = (type.eql? 'unfinded') ? 'Estudiantes no encontrados' : 'Estudiantes encontrados pero no inscritos en el curso'
      t = Time.now - 4.hours
      time = "<b>Fecha de Última Sincronización:</b> #{I18n.l(t, format: '%a, %d / %B / %Y (%I:%M%p)')}"
      aux = "<a href='/enrollment/#{self.id}/sync_up_width_canvas' class= 'btn btn-success pull-right mb-0 p-1' style='margin-bottom: 0px; padding: 6px;'><div class='fa fa-sliders'></div>Sincronizar nuevamente</a>"
      aux += "<p class= 'pull-right' style='margin-bottom: 0px; padding: 6px;'>#{time}</p>"
      aux += "</br><b>#{tipo}</b>"
      aux += "<table class='table table-striped table-sm table-hover table-condensed'>"
      aux += "<thead><tr><th>#</th><th>Nombre</th><th>Correo</th><th>Opciones</th></tr></thead>"

      list.each_with_index do |u, i|
        href = "https://canvas.instructure.com/courses/#{self.id_canvas}/users/#{u[0]}"
        aux += "<tbody><tr><td>#{i+1}</td><td>#{u[2]}</td><td>#{u[1]}</td><td><a target='_blank' href='#{href}' target='_blank'>Ver en Canvas</a><td></tr>"
      end
      aux += "</tbody></table>"
      return aux
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
    (self.period and self.course) ? "#{self.period.name} #{self.course.name} #{self.kind}" : "#{self.id}"
  end

  def desc_short
    "#{self.period.name} #{self.course.language_id} #{self.course.level_id} #{self.kind[0..2].upcase}"
  end

  protected

  def create_first_section
    sections.create(number: '0') unless sections.any?
  end

end
