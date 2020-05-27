class QualificationDetail < ApplicationRecord
  belongs_to :qualifier, foreign_key: 'qualifier_id', class_name: 'Instructor', primary_key: 'user_id'
  belongs_to :section
  accepts_nested_attributes_for :section
  accepts_nested_attributes_for :qualifier
end
