class Student < ApplicationRecord
	belongs_to :user
	validates :user_id, presence: true
	validates :identity_personal_document, presence: true, uniqueness: true
end
