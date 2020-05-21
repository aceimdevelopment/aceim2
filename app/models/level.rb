class Level < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :id, presence: true, uniqueness: true
end
