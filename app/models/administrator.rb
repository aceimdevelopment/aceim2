class Administrator < ApplicationRecord
	belongs_to :user#, foreign_key: :user_id
	# accepts_nested_attributes_for :user 
	validates :user_id, presence: true
	validates :role, presence: true
	enum role: [:Desarrollador, :SuperAdmin, :Supervidor, :Admin]

	def before_import_save(record)
		p "Fuera de la búsqueda de usuario: #{record}"
		if user_aux = User.find(record[:id])
			p "rol: #{record[:rol]}"
			self.user_id = user_aux.id
			self.role = Administrator::roles.key record[:rol].to_i
		end
	end

	def name
		"#{user.description}" if user
	end

end
