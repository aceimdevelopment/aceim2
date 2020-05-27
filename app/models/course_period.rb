class CoursePeriod < ApplicationRecord
  belongs_to :course
  belongs_to :period

  validates :course_id, presence: true
  validates :period_id, presence: true
  validates :kind, presence: true
  enum kind: [:Online, :Interdiario, :Sabatino, :Mixtos]

  has_many :sections
  accepts_nested_attributes_for :sections

  def before_import_save(record)
    if (letter_aux, year_aux = record[:period_id].split("-")) && (period = Period.where(year: year_aux, letter: letter_aux).first)
      self.period_id = period.id
    end
    if (course = Course.where(language_id: record[:language_id], level_id: record[:level_id]).first)
      self.course_id = course.id
    end
    self.kind = :Mixtos
  end

  def name
    (self.period and self.course) ? "#{self.period.name}:#{self.course.name}" : "#{self.id}"
  end

end
