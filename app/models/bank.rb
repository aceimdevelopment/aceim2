class Bank < ApplicationRecord

  # ========== RELATIONSHIPS ============ #

  has_many :payment_details, foreign_key: :source_bank_id, inverse_of: :bank

  has_many :bank_accounts

  # ========== VALIDATIONS ============ #

  validates :id, presence: true
  validates :name, presence: true

  # ========== RAILS ADMIN ============ #
  rails_admin do
    edit do
      field :id do
        label 'Identificador'
      end
      field :name do
        label 'Nombre'
      end
    end

    list do
      field :id do
        label 'Identificador'
      end
      field :name do
        label 'Nombre'
      end
      field :total_payments do
        label 'Pagos'
        formatted_value do
          bindings[:object].total_payments
        end
      end
    end
  end

  # ========== FUNTIONS ============ #
  def total_payments
    payment_details.count
  end

end
