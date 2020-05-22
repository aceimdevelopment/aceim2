class Period < ApplicationRecord
	validates :year, presence: true
	validates :year, numericality: {only_integer: true, greater_than_or_equal_to: 2005, less_than_or_equal_to: 2040}
	validates :letter, presence: true

	validates :letter, length: {maximum: 1} 

	validates :kind, presence: true
	enum kind: [:Online, :Interdiario, :Sabatino]

	def desc
		[self.year, self.letter].compact.join(' - ')
	end

end
