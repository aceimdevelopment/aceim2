class Bank < ApplicationRecord

  # ========== RELATIONSHIPS ============ #
  # Se comentó el inverse_of porque daba error en el Index y show del RailsAdmin  
  has_many :payment_details, foreign_key: :source_bank_id#, inverse_of: :bank

  has_many :bank_accounts, inverse_of: :bank

  # ========== VALIDATIONS ============ #

  validates :id, presence: true
  validates :name, presence: true

  # ========== RAILS ADMIN ============ #
  rails_admin do

    export do

      field :id do
        label 'Id'
      end
      field :name do
        label 'Nombre'
      end

    end


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
    self.payment_details.count
  end

end
