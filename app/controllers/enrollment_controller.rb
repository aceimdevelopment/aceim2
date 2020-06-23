class EnrollmentController < ApplicationController

	before_action :authenticate_user!


	def regular
		# params[:student_id] ||= current_user.id
		student = Student.find(current_user.id)
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

			if record.save
				period_id = section.course_period.period_id
				language_id = section.course_period.course.language_id
				student.academic_records.currents.from_language(language_id).from_period(period_id).first.delete

				# OJO: FORMA CORRECTA DE ELIMINAR HISTORIALES NO ONLINE
				# currents_course_period_no_online = student.academic_records.currents.from_course_perido(section.course_period_id).first
				# currents_course_period_no_online.delete if currents_course_period_no_online
				flash[:success_enrolled] = true
			else
				flash[:error] = "Error al intentar inscribir: #{record.errors.full_messages.to_sentence}"
			end

		end
		redirect_back fallback_location: root_path
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
