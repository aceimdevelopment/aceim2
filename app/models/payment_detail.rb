class PaymentDetail < ApplicationRecord
	belongs_to :academic_record
	validates :bank_account_id, presence: true

	belongs_to :source_bank, foreign_key: :source_bank_id, class_name: 'Bank'

	# belongs_to :pci_escuela, foreign_key: 'pci_escuela_id', class_name: 'Escuela', optional: true

	enum transaction_type: [:transferencia, :deposito, :efectivo]

	def name
		aux = transaction_number
		aux += academic_record.desc_to_pay
	end
end