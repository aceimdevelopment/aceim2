class CoursePeriod < ApplicationRecord
  belongs_to :course
  belongs_to :period
end
