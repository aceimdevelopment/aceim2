class Section < ApplicationRecord
  
  # ========== RELATIONSCHIPS ============ #

  belongs_to :course_period
  # accepts_nested_attributes_for :course_period
  belongs_to :instructor#, foreign_key: :instructor_id, primary_key: :user_id, optional: true
  # accepts_nested_attributes_for :instructor
  
  belongs_to :evaluator, class_name: 'Instructor', foreign_key: :evaluator_id, primary_key: :user_id, optional: true
  accepts_nested_attributes_for :evaluator

  belongs_to :qualification_datail, optional: true
  accepts_nested_attributes_for :qualification_datail

  has_one :period, through: :course_period
  has_one :course, through: :course_period
  has_one :language, through: :course
  has_one :level, through: :course

  has_many :academic_records
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

  rails_admin do

    # import do
    #   mapping_key = [:period_id, :language_id, :level_id, :number]
    #   mapping_key_list [:period_id, :language_id, :level_id, :number]
    # end

    edit do
      field :course_period do
        label 'Curso Periodo'
      end
      field :number do
        label 'número'
      end
      field :instructor do
        searchable :name
      end 

      field :evaluator do
        label 'Evaluador'
      end
      field :open do
        label '¿Abierta?'
      end
    end

    list do
      limited_pagination true
      # filters [:period, :language, :level]
      field :period do
        label 'Periodo'
        formatted_value do
          bindings[:object].period.name
        end
        sortable :letter
        filterable :letter
        searchable :letter
      end
      # field :period, :enum do
      #   label 'Periodo'
      #   enum do
      #     Period.all.collect {|p| ["#{p.year}-#{p.letter}", p.id]}
      #   end
      #   formatted_value do
      #     bindings[:object].period.name
      #   end
      #   sortable :year
      #   filterable :year
      #   searchable :year
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
      end
      field :open do
        label '¿Abierta?'
      end
      field :instructor do
        label 'Instructor'
      end
      # field :evaluator do
      #   label 'Evaluador'
      # end
      configure :registed do
        label 'PRE'
      end
      configure :enrolled do
        label 'CONF'
      end
      fields :period, :language, :level, :registed, :number, :open, :instructor, :registed, :enrolled
    end
  end

  # ========== FUNCTIONS ============ #

  def registed
    academic_records.preinscrito.count
  end

  def enrolled
    academic_records.confirmado.count
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

  def name
  	# self.course_period ? "#{number}-#{course_period.name}" : self.id.to_s
    self.number
  end
end
