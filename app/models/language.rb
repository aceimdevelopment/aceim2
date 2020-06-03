class Language < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :id, presence: true, uniqueness: true
	has_many :courses

	def total_levels
		self.courses.where("level_id != 'NI'").count
	end
end
