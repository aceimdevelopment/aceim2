class PaymentDetail < ApplicationRecord
	belongs_to :academic_record, inverse_of: :payment_detail
	validates :bank_account_id, presence: true

	belongs_to :source_bank, foreign_key: :source_bank_id, class_name: 'Bank'

	# agregar monto de pago
	# (.pdf, .png, .jpg) imagen de la transaccion

	# belongs_to :pci_escuela, foreign_key: 'pci_escuela_id', class_name: 'Escuela', optional: true

	enum transaction_type: [:transferencia, :deposito, :efectivo]

	before_destroy :check_for_files#, prepend: true

	def name
		aux = transaction_number
		aux += academic_record.desc_to_pay
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

	        field :programations do
	          label 'Imagen'
	          formatted_value do
	            bindings[:view].render(partial: "rails_admin/main/payment_receives/image", locals: {virtual_object: bindings[:object]})
	          end
	        end

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


	private

	def check_for_files
		if url_file and File.exist?(url_file)
			File.delete(url_file)
		end
	end
end