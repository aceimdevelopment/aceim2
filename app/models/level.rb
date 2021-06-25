class Level < ApplicationRecord
 
  # ========== RELATIONSHIPS ==================== #
 
  has_many :courses, inverse_of: :level
  accepts_nested_attributes_for :courses

  # has_many :course_periodos, through: :courses
  # accepts_nested_attributes_for :course_periodos
  
  # ========== VALIDATIONS ==================== #
  validates :name, presence: true, uniqueness: true
  validates :id, presence: true, uniqueness: true
  validates :grade, presence: true, uniqueness: true


  # ========== SCOPES ======================#

  default_scope { order(grade: :asc) }


  def self.nivel_to_level_id nivel_id
    aux = ''
    case nivel_id
    when 'BI'
      aux = 'BASI'
    when 'BII'
      aux = 'BASII'
    when 'BIII'
      aux = 'BASIII'
    when 'CB'
      aux = 'CONVBA'
    when 'MI'
      aux = 'INTI'
    when 'MII'
      aux = 'INTII'
    when 'MIII'
      aux = 'INTIII'
    when 'CI'
      aux = 'CONVINT'
    when 'AI'
      aux = 'AVANI'
    when 'AII'
      aux = 'AVANII'
    when 'AIII'
      aux = 'AVANIII'
    when 'CA'
      aux = 'CONVAVA'      
    end
    return aux
  end

  # ========== RAILS_ADMIN ================== #

  rails_admin do 

    export do
      field :id
      field :name do
        label 'Nombre'
      end
      field :grade do
        label 'Grado'
      end
    end

    list do
      field :id do
        label 'Identificador'
      end
      field :name do
        label 'Nombre'
      end
      field :grade do
        label 'orden'
      end

      field :total_enrollments do
        label 'Inscritos'
      end

      field :percentage_approved do
        label '% APROB'
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

      field :grade do
        label 'orden'
      end
    end

  end

  def total_enrollments
    AcademicRecord.from_level(self.id).count
  end

  def total_pi
    AcademicRecord.from_level(self.id).pi.count
  end

  def total_approved
    AcademicRecord.from_level(self.id).approved.count
  end

  def total_repproved
    AcademicRecord.from_level(self.id).repproved.count
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
