class PaymentDetail < ApplicationRecord
	belongs_to :academic_record, inverse_of: :payment_detail
	has_one :student, through: :academic_record
	has_one :user, through: :student

	belongs_to :bank_account, inverse_of: :payment_details
	belongs_to :source_bank, foreign_key: :source_bank_id, class_name: 'Bank', inverse_of: :payment_details

	has_one_attached :backup_file

	validates :bank_account_id, presence: true
	# agregar monto de pago
	# (.pdf, .png, .jpg) imagen de la transaccion

	# belongs_to :pci_escuela, foreign_key: 'pci_escuela_id', class_name: 'Escuela', optional: true

	enum transaction_type: [:transferencia, :deposito, :efectivo]

	# before_destroy :check_for_files#, prepend: true

	scope :unread_report, -> {where(read_report: false)}
	scope :unread_confirmation, -> {where(read_confirmation: false)}


	def name
		aux = transaction_number
		aux += academic_record.desc_to_pay if academic_record
	end



	rails_admin do
		list do
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
			end

			field :confirme do
				label '¿Confirmado?'
				formatted_value do
					url = "/payment_details/#{bindings[:object].id}/confirm"
					bindings[:view].render(partial: "onoff_switch_partial", locals: {virtual_object: bindings[:object], titulo: 'Confirmar', url: url, to_checked: bindings[:object].academic_record.confirmado?, id_html: 'confirm'})
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