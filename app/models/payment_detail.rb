class PaymentDetail < ApplicationRecord
	belongs_to :academic_record
	validates :bank_account_id, presence: true
end
