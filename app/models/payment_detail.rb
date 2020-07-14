class PaymentDetail < ApplicationRecord
	
  # ========== ASSOCIATION ============ #
	belongs_to :academic_record, inverse_of: :payment_detail
	has_one :student, through: :academic_record
	has_one :user, through: :student

	belongs_to :bank_account, inverse_of: :payment_details
	# Se comentó el inverse_of porque daba error en el Index y show del RailsAdmin  
	belongs_to :source_bank, foreign_key: :source_bank_id, class_name: 'Bank'#, inverse_of: :payment_details

	has_one_attached :backup_file

  # ========== VALIDATIONS ============ #
	validates :bank_account, presence: true
	validates :transaction_type, presence: true
	validates :transaction_number, presence: true
	validates :transaction_number, presence: true, uniqueness: true
	validates :source_bank, presence: true
	validates :mount, presence: true
	validates :created_at, presence: true
	# agregar monto de pago
	# (.pdf, .png, .jpg) imagen de la transaccion

	# belongs_to :pci_escuela, foreign_key: 'pci_escuela_id', class_name: 'Escuela', optional: true

  # ========== ENUM TYPE ============ #
	enum transaction_type: [:transferencia, :divisas]


	# before_destroy :check_for_files#, prepend: true


  # ========== SCOPE ============ #

	# scope :search, lambda { |clave| 
	# 	where("MATCH(ci, nombres, apellidos, email, telefono_habitacion, telefono_movil) AGAINST('#{clave}')")
	# }

	scope :my_custom_search, -> (keyword) {joins(academic_record: {student: :user}).where("transaction_number LIKE ? or students.personal_identity_document LIKE ? or users.name LIKE ? or users.email LIKE ? or users.last_name LIKE ?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%")}
	scope :unread_report, -> {where(read_report: false)}
	scope :unread_confirmation, -> {where(read_confirmation: false)}

	scope :preinscritos, -> {joins(:academic_record).where('academic_records.inscription_status = 0')}
	scope :confirmados, -> {joins(:academic_record).where('academic_records.inscription_status = 1')}

	scope :todos, -> {where('0 = 0')}

  # ========== FUNCTIONS ============ #
	def name
		aux = transaction_number
		aux += academic_record.desc_to_pay if academic_record
	end

	def preinscrito?
		(academic_record and academic_record.preinscrito?)
	end

	def preinscrito
		(academic_record and academic_record.preinscrito?)
	end

	def confirmado
		(academic_record and academic_record.confirmado?)
	end
	# def confirmados
	# 	academic_record.confirmado?
	# end

	rails_admin do

		export do
			# field :confirmado do
			#	label '¿Confirmado?'
			#	export_value do
			#		value and value.eql? true ?  'Sí' : 'No' 
			#	end
			# end
			field :transaction_number do
				label '# Transacción'
			end

			field :bank_account do 
				label 'Cuenta Bancaria'
				export_value do
					value.name if value
				end
			end

			field :source_bank do
				label 'Banco'
				export_value do
					value.name if value
				end
			end
			field :transaction_type do
				label 'Tipo'
			end			

			field :mount do
				label 'Monto'
			end

			field :created_at do
				label 'Fecha'
			end

			field :academic_record do
				label 'Inscripcion'
			end

		end

		edit do


			field :transaction_number do
				label '# Transacción'
			end

			field :transaction_type do
				label 'Tipo'
			end

			field :source_bank do
				label 'Banco'
			end

			field :mount do
				label 'Monto'
			end

			field :created_at do
				label 'Fecha'
			end


		end

		list do
			scopes [:todos, :preinscritos, :confirmados]
			search_by :my_custom_search
			field :transaction_number do
				label '# Transacción'
			end

			field :transaction_type do
				label 'Tipo'
			end

			field :source_bank do
				label 'Banco'
			end

			field :academic_record do
				label 'Inscripción'
				html_attributes do
					{:style => "width: 50%"}
				end
			end

			field :mount do
				label 'Monto'
			end

			field :created_at do
				label 'Fecha'
				strftime_format "%d/%m/%Y"
			end

			field :confirm do
				# label '¿Confirmado?'
				label do
					if bindings[:object].preinscrito?
						'Estado'
					else
						false
					end
				end
				formatted_value do
					if bindings[:object].preinscrito?
						url = "/payment_details/#{bindings[:object].id}/confirm"
						bindings[:view].render(partial: "confirmation_button", locals: {title: 'Confirmar Pago', url: url})
					else
						false
					end
				end

			end


		end

		show do

	        field :image do
	          label 'Imagen'
	          formatted_value do
	            bindings[:view].render(partial: "rails_admin/main/payment_receives/image", locals: {virtual_object: bindings[:object]})
	          end
	        end

			# field :backup_file, :active_storage do
			# 	label 'Imagen'
			# end

			field :academic_record do
				label 'Inscripción'
			end

			field :transaction_number do
				label '# Transacción'
			end

			field :transaction_type do
				label 'Tipo'
			end

			field :source_bank do
				label 'Banco'
			end

			field :mount do
				label 'Monto'
			end

			field :created_at do
				label 'Fecha'
			end
		end
	end

	def course_description
		aux = academic_record.section.course_period
		"#{aux.course.language.name} #{aux.course.level.name} (#{aux.kind.capitalize}) #{aux.period.name}"
	end


	private

	def check_for_files
		if url_file and File.exist?(url_file)
			File.delete(url_file)
		end
	end
end