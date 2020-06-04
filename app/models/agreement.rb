class Agreement < ApplicationRecord
  # ========== RELATIONSHIPS ============ #
  has_many :careers
  has_many :academic_records

  validates :id, presence: true
  validates :name, presence: true
  validates :value, presence: true
  validates :discount, presence: true

  # ========== RAILS ADMIN ============ #
  rails_admin do

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

  def total_enrollment
    # Agregar valor en función a period actual
    academic_records.confirmado.count
  end
end
