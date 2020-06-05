class Level < ApplicationRecord
 
  # ========== RELATIONSHIPS ==================== #
 
  has_many :courses
  accepts_nested_attributes_for :courses

  # has_many :course_periodos, through: :courses
  # accepts_nested_attributes_for :course_periodos
  
  # ========== VALIDATIONS ==================== #
  validates :name, presence: true, uniqueness: true
  validates :id, presence: true, uniqueness: true

  # ========== RAILS_ADMIN ================== #

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
  
end
