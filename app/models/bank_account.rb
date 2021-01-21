class BankAccount < ApplicationRecord
  # ========== RELATIONSHIPS ============ #
  
  belongs_to :bank, inverse_of: :bank_accounts

  has_many :payment_details, inverse_of: :bank_account
  has_many :instructors, inverse_of: :bank_account

  # ========== VALIDATIONS ============ #
  
  validates :id, presence: true
  validates :number, presence: true
  validates :holder, presence: true
  validates :bank_id, presence: true

  enum account_type: [:corriente, :ahorro]

  # ============ SCOPE ============== #

  scope :owns, -> {where('own IS TRUE')}

  # ========== FUNCTIONS ============ #
  def name
    "#{bank.name}: #{number} (#{holder})"
  end

  # ========== RAILS ADMIN ============ #
  rails_admin do
    export do
      field :id do
        label 'Id'
      end
      field :number do
        label 'Número'
      end
      field :holder do
        label 'Titular'
      end
      field :bank do
        label 'Banco'
      end
      # exclude_fields :created_at, :updated_at
    end

    edit do
      field :id do
        label 'Identificador'
      end
      
      field :own do
        label 'Propia'
      end

      field :number do
        label 'Número'
      end
      field :holder do
        label 'Titular'
      end
      field :bank do
        label 'Banco'
      end

      field :account_type do
        label 'Tipo de Cuenta'
      end
    end

    list do
      field :id do
        label 'Identificador'
      end
      field :number do
        label 'Número'
      end
      field :holder do
        label 'Titular'
      end
      field :bank do
        label 'Banco'
      end
      
    end
  end

  def any_blank?
    (self.number.nil? or self.holder.nil? or self.bank_id.nil? or self.account_type.nil?) ? true : false
  end

end
