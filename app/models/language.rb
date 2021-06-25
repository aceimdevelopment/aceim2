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
    export do
      field :id
      field :name do
        label 'Nombre'
      end
    end
    list do
      field :id do
        label 'Identificador'
      end
      field :name do
        label 'Nombre'
      end
      field :total_enrollments do
        label 'Inscritos'
      end

      field :percentage_approved do
        label '% ABROB'
      end

      field :percentage_repproved do
        label '% REPROB'
      end
      field :percentage_pi do
        label '% PI'
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
    self.courses.where("level_id != 'NIVE'").count
  end

  def last_level
    courses.maximum(:grade)
  end

  def total_enrollments
    AcademicRecord.from_language(self.id).count
  end

  def total_approved
    AcademicRecord.from_language(self.id).approved.count
  end

  def total_repproved
    AcademicRecord.from_language(self.id).repproved.count
  end

  def total_pi
    AcademicRecord.from_language(self.id).pi.count
  end

  def percentage_pi
    (((total_pi.to_f)*100)/(total_enrollments.to_f)).round(1)
  end
  def percentage_repproved
    (((total_repproved.to_f)*100)/(total_enrollments.to_f)).round(1)
  end
  def percentage_approved
    (((total_approved.to_f)*100)/(total_enrollments.to_f)).round(1)
  end

end
