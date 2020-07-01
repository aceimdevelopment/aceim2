class Agreement < ApplicationRecord
  # ========== RELATIONSHIPS ============ #
  has_many :careers, inverse_of: :agreement
  has_many :academic_records, inverse_of: :agreement

  # ========== VALIDATIONS ============ #
  validates :id, presence: true
  validates :name, presence: true
  validates :value, presence: true
  validates :discount, presence: true

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
      field :id
      field :name do
        label 'Nombre'
      end
      field :value do
        label 'Valor'
      end
      field :discount do
        label 'Descuento (%)'
      end
      field :enrollment do
        label 'Inscripciones'
        formatted_value do
          bindings[:object].total_enrollment
        end
      end
    end
  end

  def description
    "#{id}: #{name}"
  end

  def total_enrollment
    # Agregar valor en función a period actual
    academic_records.confirmado.count
  end
end
