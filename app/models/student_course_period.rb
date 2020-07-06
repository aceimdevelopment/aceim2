class StudentCoursePeriod < ActiveModel::Validator
  def validate(record)
    if same_course_period(record)
      record.errors.add 'inscripción', "en el curso para el período selecionado ya existe"
    end
  end

  private
    def same_course_period(record)
    	student_id = record.student_id
    	course_period_id = record.section.course_period_id
    	AcademicRecord.joins(:section).where('student_id = ? and sections.course_period_id = ?', student_id, course_period_id).any?
    end
end