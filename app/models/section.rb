class Section < ApplicationRecord
  belongs_to :course_period
  # accepts_nested_attributes_for :course_period

  belongs_to :instructor, class_name: 'Instructor', foreign_key: :instructor_id, primary_key: :user_id, optional: true
  accepts_nested_attributes_for :instructor
  
  belongs_to :evaluator, class_name: 'Instructor', foreign_key: :evaluator_id, primary_key: :user_id, optional: true
  accepts_nested_attributes_for :evaluator

  belongs_to :qualification_datail, optional: true
  accepts_nested_attributes_for :qualification_datail

  has_one :period, through: :course_period
  has_one :course, through: :course_period

  validates :number, presence: true
  validates :course_period_id, presence: true
  # validates :instructor_id, presence: true

  validates :number, uniqueness: { scope: :course_period_id }

  # validates_uniqueness_of :horario_id, scope: [:dia, :entrada], message: 'Ya existe un horario con una hora de entrada igual para la sección.', field_name: false

  # validates_uniqueness_of :number, scope: [:course_period_id], message: 'La sección ya existe para el período seleccionado', field_name: false, case_sensitive: true

  def before_import_save(record)
    if (letter_aux, year_aux = record[:period_id].split("-")) && (period_aux = Period.where(year: year_aux, letter: letter_aux).first) &&
      (course_aux = Course.where(language_id: record[:language_id], level_id: record[:level_id]).first)
      course_period_aux = CoursePeriod.where(period_id: period_aux.id, course_id: course_aux.id).first
      self.course_period_id = course_period_aux.id
    end

    if (email = record[:instructor_email]) && (user_aux = User.find_by_email(email))
      self.instructor_id = user_aux.id
    end
    if (email = record[:evaluator_email]) && (user_aux = User.find_by_email(email))
      self.evaluator_id = user_aux.id
    end

  end

  def name
  	self.course_period ? "#{number}-#{course_period.name}" : self.id.to_s
  end
end
