class Student < ApplicationRecord
	belongs_to :user
	validates :user_id, presence: true
	validates :personal_identity_document, presence: true, uniqueness: true
	
end
