class Language < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :id, presence: true, uniqueness: true
	has_many :courses
end
