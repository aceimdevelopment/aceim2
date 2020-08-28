class GeneralSetup < ApplicationRecord

  validates :id, presence: true

  def self.video_tuto_canvas_value
    aux = GeneralSetup.where(id: "VIDEO_TUTORIAL_CANVAS").first
    (aux and aux.value) ? aux.value : ''
  end

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

  def self.fundeim_phone_value
    aux = GeneralSetup.where(id: "TELEFONOS_FUNDEIM").first
    aux ? aux.value : 'Tlfs: (0212) 605-1802 / 605-2982'
  end

  def self.fundeim_email_value
    aux = GeneralSetup.where(id: "EMAIL_FUNDEIM").first
    aux ? aux.value : 'fundeimucv@gmail.com'
  end

  def self.payment_receive
    aux = GeneralSetup.where(id: "HORARIO_ATENCION").first
  end

  def self.payment_receive_value
    self.payment_receive ? self.payment_receive.value : 'Por definir'
  end

  def self.message_payment_report
    aux = GeneralSetup.where(id: "MENSAJE_REPORTE_PAGO").first
    aux ? aux.value : 'Estimado(a) estudiante, usted ha reportado un pago a través de nuestra página web. Hemos enviado a su correo el detalle de la transacción.'
  end

  def self.amount_divisa_date
    aux = GeneralSetup.where(id: "FECHA_MONTO_DIVISA").first
    aux ? aux.value : 'Este monto es válido si realiza la transferencia antes de las 6:00pm del día de hoy. Luego de esa hora deberá consultar aquí si ha habido algún cambio en el monto del arancel del inscripción.'
  end
  
  def self.link_survey
    aux = GeneralSetup.where(id: "ENLACE_ENCUESTA").first
    aux ? aux.value : 'https://docs.google.com/forms/d/1BMpk8P1MsO8G8N8lzhhCG2hfsH9yr3u0_j_Sbk73LIY/edit?usp=sharing'
  end

	rails_admin do
    list do
      checkboxes false
      field :id do
        read_only true
        label 'Identificador'
      end
      field :value do
        label 'Valor'
        column_width 700
      end
    end     
    show do
      field :id do
        read_only true
        label 'Identificador'
      end
      field :value do
        label 'Valor'
      end
    end

    update do
      field :id do
        read_only true
        label 'Identificador'
      end
      field :value do
        label 'Valor'
      end
    end

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
    end
	end


end
# MOSTRAR_ENLACE_CANVAS