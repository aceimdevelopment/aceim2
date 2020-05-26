class CoursePeriod < ApplicationRecord
  belongs_to :course
  belongs_to :period

  has_many :sections
  accepts_nested_attributes_for :sections

	def name
		(self.period and self.course) ? "#{self.period.name}:#{self.course.name}" : "#{self.id}"
	end

end
