class QualificationDetail < ApplicationRecord
  belongs_to :qualifier, foreign_key: :qualifier_id, class_name: 'Instructor'
  accepts_nested_attributes_for :qualifier
end
