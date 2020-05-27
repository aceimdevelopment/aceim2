class Period < ApplicationRecord
	validates :year, presence: true
	validates :year, numericality: {only_integer: true, greater_than_or_equal_to: 2005, less_than_or_equal_to: 2040}
	validates :letter, presence: true

	validates :letter, length: {maximum: 1}

	validates_uniqueness_of :year, scope: :letter, message: 'Período ya creado', field_name: false 

	# validates_uniqueness_of :horario_id, scope: [:dia, :entrada], message: 'Ya existe un horario con una hora de entrada igual para la sección.', field_name: false

	def name
		[self.letter, self.year].compact.join('-')
	end
end
