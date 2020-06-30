class EnrollmentController < ApplicationController

	before_action :authenticate_user!

	def regular
		# params[:student_id] ||= current_user.id
		student = Student.find(params[:student_id])
		if student.nil?
			flash[:error] = "Disculpa, el usuario no se encuentra registrado como estudiante"
		else
			section = Section.find params[:id]
			career = student.careers.where(language_id: section.language.id).first
			agreement_id = career.agreement_id if career

			record = AcademicRecord.new
			record.student_id = student.user_id
			record.section_id = section.id
			record.agreement_id = agreement_id

			record.inscription_status = 'confimado' if career.agreement.value.eql? 0

			if record.save
				# TRATAMIENTO DE CASOS ESPECIALES DEL PERIODO 2020
				# period_id = section.course_period.period_id
				period_ids = [12,25]

				language_id = section.course_period.course.language_id
				currents_course_period_no_online = student.academic_records.currents.from_language(language_id).from_periods(period_ids).first
				if currents_course_period_no_online
					currents_course_period_no_online.delete 
					flash[:success_enrolled] = true
					# "<h3> ¡Haz completado el primer paso satisfactoriamente!</h3><p>Te invitamos amablemente a realizar el pago correspondiente siguiendo los datos a continuación:</p>"
				else
					flash[:payment_accounts] = true
				end
			else
				flash[:error] = "Error al intentar inscribir: #{record.errors.full_messages.to_sentence}"
			end
			redirect_back fallback_location: root_path

		end
	end

	# def regular
	# 	params[:student_id] ||= current_user.id
	# 	student = Student.find(params[:student_id])
	# 	if student.nil?
	# 		flash[:error] = "Disculpa, el usuario no se encuentra registrado como estudiante"
	# 	else
	# 		course_period = CoursePeriod.find(params[:id])
	# 		if course_period.nil?
	# 			flash[:error] = "Disculpa, curso no disponible para este periodo"
	# 		else
	# 			career = student.careers.where(language_id: course_period.language.id).first
	# 			if career.nil?
	# 				flash[:error] = "Disculpa. el estudiante debe estar registrado en #{course_period.language.name.capitalize}"
	# 			else
	# 				agreement_id = career.agreement_id

	# 				sections = course_period.sections
	# 				unless sections.any?
	# 					flash[:error] = "Disculpa, el curso no tiene secciones"
	# 				else
	# 					p "  ¡¡¡ ELSE DE SECCIONES. PENÚLTIMO IF!!!  ".center(200,"=")

	# 					# AQUÍ SE DEBE VALIDAR LA DISPONIBILIDAD DE LA SECCIÓN EN EL CASO DE LAS PRESENCIALES
	# 					# TAMBIÉN SE DEBE CONTROLAR LA DISTRIBUCIÓN EN LAS SECCIONES

	# 					if course_period.academic_records.where(student_id: current_user.id).any?
	# 						flash[:error] = "Disculpa, estudiante ya inscrito en el curso"
	# 					else
	# 						p "  ¡¡¡ESTOY EN EL ÚLTIMO IF!!!  ".center(200,"=")
	# 						record = AcademicRecord.new
	# 						record.student_id = params[:student_id]
	# 						record.section_id = sections.first.id
	# 						record.agreement_id = agreement_id

	# 						if record.save
	# 							flash[:success] = "¡Inscripción realizada con éxito!"
	# 						else
	# 							flash[:error] = "Error al intentar inscribir: #{record.error.full_message.to_sentences}"
	# 						end
	# 					end
	# 				end
	# 			end
	# 		end
	# 	end
	# 	redirect_back fallback_location: root_path
	# end
end
