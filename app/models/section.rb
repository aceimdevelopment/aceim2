class Section < ApplicationRecord
  belongs_to :course_period
  belongs_to :instructor
  belongs_to :qualification_datail

  validates :number, presence: true
  validates :course_period_id, presence: true
  validates :instructor_id, presence: true

  validates_uniqueness_of [:number, :course_period_id], message: 'La sección ya existe para el período seleccionado', field_name: false


  def name
  	self.course_period ? "#{number}-#{course_period.name}" : self.id.to_s
  end
end
