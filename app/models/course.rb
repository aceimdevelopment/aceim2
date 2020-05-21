class Course < ApplicationRecord
  belongs_to :language
  belongs_to :level

  validates :language_id, presence: true
  validates :level_id, presence: true
  validates :grade, presence: true

end
