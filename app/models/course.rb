class Course < ApplicationRecord
  # ================ ASSOCIATIONS ================== # 
  belongs_to :language, inverse_of: :courses
  belongs_to :level, inverse_of: :courses

  has_many :course_periods, inverse_of: :course
  accepts_nested_attributes_for :course_periods


  # ================ VALIDATIONS ================== # 
  validates :language_id, presence: true
  validates :level_id, presence: true
  validates :grade, presence: true

  def next_course
    Course.where(language_id: self.language_id, grade: self.grade+1).first 
  end

  def name
  	self.language and self.level ? "#{self.language.name}-#{self.level.name}" : "#{self.id}"
  end
end
