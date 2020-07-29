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
    when 'CM'
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
  
end
