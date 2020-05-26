class AcademicRecord < ApplicationRecord
  belongs_to :student
  belongs_to :section
  belongs_to :agreement
  belongs_to :payment_detail

  enum status: [:Preinscrito, :confirmado]
end
