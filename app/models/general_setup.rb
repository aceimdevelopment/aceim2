class GeneralSetup < ApplicationRecord

	def self.permitir_registros_nuevos
		aux = GeneralSetup.where(id: "PERMITIR_NUEVOS_REGISTROS").first
		(aux and aux.value.eql? 'SI')
	end

  def self.url_canvas_login
    aux = GeneralSetup.where(id: "CANVAS_LOGIN_URL").first
    aux.value ? aux.value : '#'
  end

	def self.mostrar_enlace_canvas
		aux = GeneralSetup.where(id: "MOSTRAR_ENLACE_CANVAS").first
		(aux and aux.value.eql? 'SI')
	end

  def self.fundeim_location
    aux = GeneralSetup.where(id: "UBICACION_FUNDEIM").first
  end

  def self.fundeim_location_value
    self.fundeim_location ? self.fundeim_location.value : 'Galpones - Ciudad Universitaria'
  end

  def self.payment_receive
    aux = GeneralSetup.where(id: "HORARIO_ATENCION").first
  end

  def self.payment_receive_value
    self.payment_receive ? self.payment_receive.value : 'Por definir'
  end

	rails_admin do
      edit do
        field :id do
          label 'Identificador'
          html_attributes do
            {:onInput => "$(this).val($(this).val().toUpperCase().replace(/[^A-Z|0-9|_]/g,''))"}
          end        
        end
        field :value do
          label 'Valor'
          # html_attributes do
          #   {:onInput => "$(this).val($(this).val().toUpperCase().replace(/[^A-Z|0-9|]/g,''))"}
          # end
        # help 'Solo un caracter permitido'
        end
        # exclude_fields :created_at, :updated_at
      end
	end


end
# MOSTRAR_ENLACE_CANVAS