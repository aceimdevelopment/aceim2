class PaymentDetail < ApplicationRecord
	validates :bank_account_id, presence: true
end
