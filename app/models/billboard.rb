class Billboard < ApplicationRecord

	has_rich_text :content
	validates :content, presence: true
	validates :name, presence: true
	validates :sequence, presence: true

	scope :enableds, -> {where(enabled: true)}

	rails_admin do

		edit do
			field :name do 
				label 'Nombre'
			end
			field :enabled do
				label 'Activar'
			end
			field :sequence do
				label 'Orden'
			end
			field :content, :actiontext do
				label 'Contenido'
			end
		end

		list do
			field :name do
				label 'Nombre'
			end
			field :enabled do
				label 'Activa'
			end
			field :sequence do 
				label 'Orden'
			end
		end

	end
end
