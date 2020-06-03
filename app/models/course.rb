class Course < ApplicationRecord
  belongs_to :language
  belongs_to :level

  validates :language_id, presence: true
  validates :level_id, presence: true
  validates :grade, presence: true

  has_many :course_periods
  accepts_nested_attributes_for :course_periods

  def next_course
    Course.where(language_id: self.language_id, grade: self.grade+1).first 
  end

  def name
  	self.language and self.level ? "#{self.language.name}-#{self.level.name}" : "#{self.id}"
  end
end
