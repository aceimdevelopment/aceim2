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

  # ================ SCOPE ================== # 
  scope :without_nevel, -> {where("level_id != 'NIVE'")}
  default_scope { order([language_id: :asc, grade: :asc]) }
  # ================ FUNCTIONS ================== # 

  def next_course
    Course.where(language_id: self.language_id, grade: self.grade+1).first 
  end

  def name
  	self.language and self.level ? "#{self.language.name}-#{self.level.name}" : "#{self.id}"
  end

  rails_admin do
    export do
      field :language do
        label 'Iidoma'
      end
      field :level do
        label 'Nivel'
      end
    end
  end
end
