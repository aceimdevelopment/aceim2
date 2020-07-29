class Language < ApplicationRecord
  
  # ========== RELATIONSHIPS ==================== #
  
  has_many :courses, inverse_of: :language
  accepts_nested_attributes_for :courses

  has_many :careers, inverse_of: :language
  accepts_nested_attributes_for :careers

  # has_many :course_periodos, through: :courses
  # accepts_nested_attributes_for :course_periodos
  
  # ========== VALIDATIONS ==================== #
  validates :name, presence: true, uniqueness: true
  validates :id, presence: true, uniqueness: true

  # ========== RAILS_ADMIN ================== #

    def self.idioma_to_language_id idioma_id
    aux = ''
    case idioma_id
    when 'IN'
      aux = 'ING'
    when 'IT'
      aux = 'ITA'
    when 'AL'
      aux = 'ALE'
    when 'FR'
      aux = 'FRA'
    when 'PG'
      aux = 'POR'
    end
    return aux
  end


  rails_admin do 
    list do
      field :id do
        label 'Identificador'
      end
      field :name do
        label 'Nombre'
      end
    end

    edit do
      field :id do
        label 'Identificador'
      end
      field :name do
        label 'Nombre'
      end
    end
  end


  # ========== FUNCTIONS ==================== #
  def first_course
    # courses.where(grade: 1).first
    courses.where('grade > 0').order(grade: :asc).first
  end

  def total_levels
    self.courses.where("level_id != 'NI'").count
  end

  def last_level
    courses.maximum(:grade)
  end
end
