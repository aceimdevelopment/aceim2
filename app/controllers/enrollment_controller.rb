class EnrollmentController < ApplicationController

  before_action :authenticate_user!

  def import_aceim_old
    @student = Student.find params[:id]
    type, msg = @student.import_from_aceim_local
    flash[type] = msg
    redirect_back fallback_location: root_path
  end


  def sync_up_width_canvas
    begin
      unfinded = []
      unenrolled = []
      course_period = CoursePeriod.find params[:id]
      course_period_id = course_period.id
      course_id_canvas = course_period.id_canvas
      canvas = MyCanvas.connect
      sections = canvas.get("/api/v1/courses/#{course_id_canvas}/sections",{per_page: 20}) #get_sections_of_course(course_id_canvas)

      sections.each do |s|
        section_id_canvas = s['id']
        number_aceim = (s['name'].last 2).to_i
        s2 = Section.where(id_canvas: section_id_canvas).first
        s2 ||= Section.where(number: number_aceim, course_period_id: course_period_id).first
        s2 ||= Section.new
        s2.course_period_id = course_period_id
        s2.number = number_aceim
        s2.id_canvas = section_id_canvas

        # instructor = canvas.get_enrollments_to_section(id_canvas, 'TaEnrollment').first
        instructor = canvas.get("/api/v1/sections/#{section_id_canvas}/enrollments", {per_page: 10, role: 'TaEnrollment'}).first

        if instructor
          email_instr = instructor['user']['login_id']
          i_aux = User.where("email = '#{email_instr}' OR login_id_canvas = '#{email_instr}'").first
          s2.instructor_id = i_aux.id if i_aux
        end

        if s2.save
          # enrollments = canvas.get_enrollments_to_section(id_canvas, 'StudentEnrollment')
          enrollments = canvas.get("/api/v1/sections/#{section_id_canvas}/enrollments", {per_page: 50, role: 'StudentEnrollment'})

          enrollments.reject{|enrolled| enrolled['user']['name'].eql? 'Test Student' or enrolled['user']['name'].eql? 'Estudiante de prueba'}.each do |ele|
            email = ele['user']['login_id']
            user = User.where("email = '#{email}' OR canvas_email = '#{email}' OR login_id_canvas = '#{email}'").first

            if user and es = user.student
              user.update(id_canvas: ele['user']['id'], canvas_email: email, login_id_canvas: email)
              if enrolled = es.academic_records.joins({section: :course_period}).where("course_periods.id = #{course_period_id}").first
              # if enrolled = es.academic_records.joins(:course_period).where("course_periods.id = #{course_period_id}").first
                enrolled.section_id = s2.id
                enrolled.inscription_status = :asignado if enrolled.confirmado?
                enrolled.save!
              else
                unenrolled << [ele['user']['id'], email, ele['user']['name']]
              end
            else
              unfinded << [ele['user']['id'], email, ele['user']['name']]
            end
          end
        else
          flash[:error] = "No se pudo guardar la sección: #{s2.errors.full_messages.to_sentence}. #{s2.attributes}"
        end
      end
      
      flash[:success] = 'Sincronización realizada con éxito'
    rescue Exception => e
      flash[:error] = "Error: #{e}"
    end

    if unenrolled.any?
      session[:course_period_id] = course_period.id
      flash[:warning] = "Algunos estudiantes no están inscritos. Revise el área de las secciones para mayor detalle."
      # session[:unenrolled] = unenrolled.first(21) #course_period.canvas_format_response(unenrolled, 'unenrolled')
      course_period.update(response_unenrolled_canvas: course_period.canvas_format_response(unenrolled, 'unenrolled'))
    else
      course_period.update(response_unenrolled_canvas: nil)
    end
    if unfinded.any?
      session[:course_period_id] = course_period.id
      flash[:danger] = "Algunos estudiantes no fueron encontrados. Revise el área de las secciones para mayor detalle."
      # session[:unfinded] = unfinded.first(21) #course_period.canvas_format_response(unfinded, 'unfinded')
      course_period.update(response_unfinded_canvas: course_period.canvas_format_response(unfinded, 'unfinded'))
    else
      course_period.update(response_unfinded_canvas: nil)
    end

    redirect_back fallback_location: '/admin/course_period'
  end

  def regular
    # params[:student_id] ||= current_user.id
    student = Student.find(params[:student_id])
    if student.nil?
      flash[:error] = "Disculpa, el usuario no se encuentra registrado como estudiante"
    else
      section = Section.find params[:id]
      cp = section.course_period

            total_enrolls = cp.academic_records.preinscrito.count
            availables = cp.capacity - total_enrolls
            # disabled = (availables <= 0)
            if (availables > 0)
        career = student.careers.where(language_id: section.language.id).first
        agreement_id =  (career and career.agreement and !section.course_period.online?) ? career.agreement_id : Agreement::REG

        record = AcademicRecord.new
        record.student_id = student.user_id
        record.section_id = section.id
        record.agreement_id = agreement_id

        # Si el precio del convevenio es cero
        # record.inscription_status = 'confimado' if career and career.agreement and career.agreement.value.eql? 0

        if record.save
          flash[:success] = '¡Inscripción realizada con éxito!'
          # TRATAMIENTO DE CASOS ESPECIALES DEL PERIODO 2020
          # period_id = section.course_period.period_id
          flash[:payment_accounts] = true
          # period_ids = [12,25]

          # language_id = section.course_period.course.language_id
          # currents_course_period_no_online = student.academic_records.currents.from_language(language_id).from_periods(period_ids).first
          # if currents_course_period_no_online
          #   currents_course_period_no_online.delete 
          #   flash[:success_enrolled] = true
          #   # "<h3> ¡Haz completado el primer paso satisfactoriamente!</h3><p>Te invitamos amablemente a realizar el pago correspondiente siguiendo los datos a continuación:</p>"
          # else
          # end
        else
          flash[:error] = "Error al intentar inscribir: #{record.errors.full_messages.to_sentence}"
        end
      else
        flash[:error] = "¡Se terminaron los cupos para éste idiama por éste período! Te invitamos a estar atento a nuevas inscripciones"
      end
      redirect_back fallback_location: root_path
    end
  end

  # def regular
  #   params[:student_id] ||= current_user.id
  #   student = Student.find(params[:student_id])
  #   if student.nil?
  #     flash[:error] = "Disculpa, el usuario no se encuentra registrado como estudiante"
  #   else
  #     course_period = CoursePeriod.find(params[:id])
  #     if course_period.nil?
  #       flash[:error] = "Disculpa, curso no disponible para este periodo"
  #     else
  #       career = student.careers.where(language_id: course_period.language.id).first
  #       if career.nil?
  #         flash[:error] = "Disculpa. el estudiante debe estar registrado en #{course_period.language.name.capitalize}"
  #       else
  #         agreement_id = career.agreement_id

  #         sections = course_period.sections
  #         unless sections.any?
  #           flash[:error] = "Disculpa, el curso no tiene secciones"
  #         else
  #           p "  ¡¡¡ ELSE DE SECCIONES. PENÚLTIMO IF!!!  ".center(200,"=")

  #           # AQUÍ SE DEBE VALIDAR LA DISPONIBILIDAD DE LA SECCIÓN EN EL CASO DE LAS PRESENCIALES
  #           # TAMBIÉN SE DEBE CONTROLAR LA DISTRIBUCIÓN EN LAS SECCIONES

  #           if course_period.academic_records.where(student_id: current_user.id).any?
  #             flash[:error] = "Disculpa, estudiante ya inscrito en el curso"
  #           else
  #             p "  ¡¡¡ESTOY EN EL ÚLTIMO IF!!!  ".center(200,"=")
  #             record = AcademicRecord.new
  #             record.student_id = params[:student_id]
  #             record.section_id = sections.first.id
  #             record.agreement_id = agreement_id

  #             if record.save
  #               flash[:success] = "¡Inscripción realizada con éxito!"
  #             else
  #               flash[:error] = "Error al intentar inscribir: #{record.error.full_message.to_sentences}"
  #             end
  #           end
  #         end
  #       end
  #     end
  #   end
  #   redirect_back fallback_location: root_path
  # end
end
