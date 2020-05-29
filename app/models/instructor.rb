class Instructor < ApplicationRecord
	belongs_to :user, foreign_key: :user_id
	accepts_nested_attributes_for :user
	validates :user_id, presence: true

	def before_import_save(record)
		self.user_id = record[:user_id]
		# if (email = record[:user_email]) && (user_aux = User.find_by_email(email))
			# self.user_id = user_aux.id
		self.active = record[:active]
		# end
	end
end
