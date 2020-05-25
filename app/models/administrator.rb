class Administrator < ApplicationRecord
	belongs_to :user
	validates :user_id, presence: true
	validates :role, presence: true
	enum role: [:Simple, :Supervidor, :SuperAdmin]
end
