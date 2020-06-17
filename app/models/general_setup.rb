class GeneralSetup < ApplicationRecord

	def self.permitir_registros_nuevos
		aux = GeneralSetup.where(id: "PERMITIR_NUEVOS_REGISTROS").first
		(aux and aux.value.eql? 'SI')
	end

	def self.mostrar_enlace_canvas
		aux = GeneralSetup.where(id: "MOSTRAR_ENLACE_CANVAS").first
		(aux and aux.value.eql? 'SI')
	end

	rails_admin do
      edit do
        field :id do
          label 'Identificados'
          html_attributes do
            {:onInput => "$(this).val($(this).val().toUpperCase().replace(/[^A-Z|0-9|_]/g,''))"}
          end        
        end
        field :value do
          label 'Valor'
          html_attributes do
            {:onInput => "$(this).val($(this).val().toUpperCase().replace(/[^A-Z|0-9|]/g,''))"}
          end
        # help 'Solo un caracter permitido'
        end
        # exclude_fields :created_at, :updated_at
      end
	end


end
# MOSTRAR_ENLACE_CANVAS