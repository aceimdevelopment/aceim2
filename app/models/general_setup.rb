class GeneralSetup < ApplicationRecord

	def self.permitir_registros_nuevos
		aux = GeneralSetup.find "PERMITIR_NUEVOS_REGISTROS"
		(aux and aux.value.eql? 'SI')
	end
end
