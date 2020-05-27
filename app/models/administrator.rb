class Administrator < ApplicationRecord
	belongs_to :user, foreign_key: :user_id
	accepts_nested_attributes_for :user 
	validates :user_id, presence: true
	validates :role, presence: true
	enum role: [:Simple, :Supervidor, :SuperAdmin]
end
