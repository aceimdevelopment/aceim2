class Career < ApplicationRecord
  belongs_to :agreement
  belongs_to :language
  belongs_to :student

  validates :agreement_id, presence: true
  validates :language_id, presence: true
  validates :student_id, presence: true

end
