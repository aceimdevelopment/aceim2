class BankAccount < ApplicationRecord
  belongs_to :bank

  validates :id, presence: true
  validates :number, presence: true
  validates :holder, presence: true
  validates :bank_id, presence: true

end
