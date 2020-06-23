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

  # validates_uniqueness_of :horario_id, scope: [:dia, :entrada], message: 'Ya existe un horario con una hora de entrada igual para la sección.', field_name: false

  # validates_uniqueness_of :number, scope: [:course_period_id], message: 'La sección ya existe para el período seleccionado', field_name: false, case_sensitive: true

  # ========== SCOPE ============ #


  # ========== RAILS ADMIN ============ #

  # def render_partial(elements)
  #   partial "user_state_partial", locals: {field: self}
  # end

  rails_admin do
    # inline_add false
    # import do
    #   mapping_key = [:period_id, :language_id, :level_id, :number]
    #   mapping_key_list [:period_id, :language_id, :level_id, :number]
    # end

    show do
      field :description do
        label 'Descripción'
        read_only true
      end
      field :open do
        label '¿Abierta?'
      end
      field :url_classroom_canvas do
        label 'Url de Aula en Canvas'
      end
      field :records do
        label 'Inscripciones'
        formatted_value do

          # bindings[:object].academic_records.map{|ar| "<p>#{ar.student.personal_identity_document},#{ar.student.user.name},#{ar.student.user.last_name}#{ar.student.user.email} </p>".html_safe}

          bindings[:view].render(partial: "table_academic_records_partial", locals: {field: self})

          # field = bindings[:object]

          # view.concat "HOLA MUNDO"
          # view.content_tag :table, {class: 'table table table-striped table-sm table-hover table-bordered table-responsive-md mt-3'} do
          #   view.content_tag :thead do
          #     view.content_tag :tr do
          #       view.content_tag( :th, 'CI' ) + 
          #       view.content_tag( :th, 'Nombres' ) + 
          #       view.content_tag( :th, 'Apellidos' ) + 
          #       view.content_tag( :th, 'emails' )
          #     end
          #   end
          #   view.content_tag :tbody do
          #     view.content_tag :tr do
          #       bindings[:object].academic_records.collect do |ar|
          #         view.content_tag( :td, ar.student.personal_identity_document ) + 
          #         view.content_tag( :td, ar.student.user.name ) + 
          #         view.content_tag( :td, ar.student.user.last_name ) + 
          #         view.content_tag( :td, ar.student.user.email )
          #       end
          #     end
          #   end
          # end

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
      field :url_classroom_canvas do
        label 'Url de Aula en Canvas'
      end
      field :instructor_id, :enum do
        enum do
          Instructor.all.map{|inst| [inst.name, inst.id]}
        end
      end
      # field :academic_records do
      #   label 'Inscripciones'
      #   partial "user_state_partial", locals: {field: self}
      # end

    end

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

      field :url_classroom_canvas do
        label 'Url Aula de Canvas'
      end

      field :open do
        label '¿Abierta?'
      end
    end

    list do
      limited_pagination true
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
      field :number do
        label 'número'
        filterable false
      end

      # field :course_period do 
      #   label 'Tipo'
      #   formatted_value{ bindings[:object].course_period.kind}
      #   queryable true
      #   sortable "course_periods.kind"
      #   filterable true
      #   searchable false
      # end
      field :course_period_kind, :enum do
        label 'Tipo'
        enum do
          CoursePeriod::kinds
        end

        # queryable true
        sortable "course_periods.kind" #CoursePeriod::kinds.keys
        filterable false # "sections_course_periods.kind"
        searchable false
      end
      field :instructor do
        label 'Instructor'
      end
      # field :evaluator do
      #   label 'Evaluador'
      # end

      field :open do
        label '¿Abierta?'
      end      
      field :registed do
        label 'PRE'
      end
      field :enrolled do
        label 'CONF'
      end

      field :aula do
        label 'Aula Canvas'
        formatted_value{ bindings[:object].url_classroom_canvas.split("/").last if bindings[:object].url_classroom_canvas }
      end
      # fields :period, :language, :level, :registed, :number, :open, :instructor, :registed, :enrolled
    end
  end

  # ========== FUNCTIONS ============ #

  def number_to_string
    sprintf("%02i",self.number)
  end

  def registed
    academic_records.preinscrito.count
  end

  def enrolled
    academic_records.confirmado.count
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

  def description
    self.course_period ? "#{number}|#{course_period.name}" : self.id.to_s
  end
  def desc_short
    self.course_period ? "#{course_period.desc_short} #{number}" : self.id.to_s
  end

  def name
    # if controller_name.eql? 'academic_record' and action_name.eql? 'new'
    # else
    #   self.number
    # end
    self.course_period ? "#{course_period.name}-#{number}" : number
  end
end
