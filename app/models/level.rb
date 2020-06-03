class Level < ApplicationRecord
	# ========== RELATIONSHIPS ==================== #
	has_many :courses
	accepts_nested_attributes_for :courses

	has_many :course_periodos, through: :courses
	accepts_nested_attributes_for :course_periodos
	
	# ========== VALIDATIONS ==================== #
	validates :name, presence: true, uniqueness: true
	validates :id, presence: true, uniqueness: true
end
