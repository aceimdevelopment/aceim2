class QualificationSchema < ApplicationRecord
  belongs_to :period, inverse_of: :qualification_schemas
  has_many :partial_qualifications, inverse_of: :qualification_schema

  validates :sequence, presence: true
  validates :percentage, presence: true
  validates :name, presence: true

  validates :sequence, uniqueness: { scope: :period_id}
  validates_with TotalPercentageValidator

  def desc
    "#{name} (#{percentage}%)"
  end

  def eva
    "EVA-#{sprintf("%02i",self.sequence)}"
  end

  rails_admin do
    list do
      field :period do 
        label 'Periodo' 
      end
      field :name do
        label 'Nombre'
      end
      field :sequence do
        label 'Orden'
      end
      field :percentage do
        label 'Porcentaje'
      end
    end


    edit do
      field :period do 
        label 'Periodo'
      end
      field :sequence do
        label 'Orden'
      end
      field :percentage do
        label 'Porcentaje'
      end
      field :name do
        label 'Nombre'
      end
    end
  end

end
