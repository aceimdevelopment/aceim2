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
  def total_levels
    self.courses.where("level_id != 'NI'").count
  end
end
