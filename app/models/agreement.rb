class Agreement < ApplicationRecord
  # ========== RELATIONSHIPS ============ #
  has_many :careers, inverse_of: :agreement
  has_many :academic_records, inverse_of: :agreement

  # ========== VALIDATIONS ============ #
  validates :id, presence: true
  validates :name, presence: true
  validates :value, presence: true
  validates :discount, presence: true


  after_save :update_percents_and_values
  # ========== CONSTANTS ============ #
  REG = 'REG'

  # ========== RAILS ADMIN ============ #
  rails_admin do


    show do
      field :id do
        label 'Identificador'
      end
      field :description do
        label 'Nombre'
      end
      field :value do
        label 'Valor'
      end
      field :discount do
        label 'Descuento'
      end
      field :total_enrollment do
        label 'Total de Inscripciones'
      end
    end

    edit do
      field :id do
        label 'Identificador'
      end
      field :name do
        label 'Nombre'
      end
      field :value do
        label 'Valor'
      end
      field :discount do
        label 'Descuento'
      end
    end

    list do
      checkboxes false
      field :id
      field :name do
        label 'Nombre'
      end
      field :amount do
        label 'Total A Pagar'
      end
      field :discount_percent do
        label 'Descuento'
      end
      field :enrollment do
        label 'Inscripciones'
        formatted_value do
          bindings[:object].total_enrollment
        end
      end
    end
  end

  def discount_percent
    "#{discount} %"
  end

  def amount
    ActionController::Base.helpers.number_to_currency(value, unit: 'Bs.', separator: ",", delimiter: ".")
  end

  def description
    "#{id}: #{name}"
  end

  def total_enrollment
    # Agregar valor en función a period actual
    academic_records.confirmado.count
  end

  private

  def update_percents_and_values

    if (id.eql? 'REG')
      Agreement.where("id != 'REG'").each do |ag|
        aux_value = (ag.discount) ? (value*((100-ag.discount.to_f)/100)).to_i : value 
        ag.update(value: aux_value)
      end
    end
    
  end

end
