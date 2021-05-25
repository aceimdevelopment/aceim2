class SectionsController < ApplicationController
	before_action :set_section, except: [:index, :new, :create, :rollback_split]
	before_action :authenticate_user!



	def sync_up_with_canvas

			unfinded = []
			unenrolled = []
			section_id_canvas = @section.id_canvas
			canvas = MyCanvas.connect
			# section_canvas = canvas.get("/api/v1/sections/#{section_id_canvas}") #get_sections_of_course(course_id_canvas)

			# instructor = canvas.get_enrollments_to_section(id_canvas, 'TaEnrollment').first
			instructor = canvas.get("/api/v1/sections/#{section_id_canvas}/enrollments", {per_page: 10, role: 'TaEnrollment'}).first

			if instructor
				email_instr = instructor['user']['login_id']
				i_aux = User.where("email = '#{email_instr}' OR login_id_canvas = '#{email_instr}'").first
				@section.instructor_id = i_aux.id if i_aux
			end

			if @section.save
				enrollments = canvas.get("/api/v1/sections/#{section_id_canvas}/enrollments", {per_page: 50, role: 'StudentEnrollment'})

				enrollments.reject{|enrolled| enrolled['user']['name'].eql? 'Test Student' or enrolled['user']['name'].eql? 'Estudiante de prueba'}.each do |ele|
					email = ele['user']['login_id']
					user = User.where("email = '#{email}' OR canvas_email = '#{email}' OR login_id_canvas = '#{email}'").first

					if user and es = user.student
						user.update(id_canvas: ele['user']['id'], canvas_email: email, login_id_canvas: email)
						if enrolled = es.academic_records.joins(:section).where("sections.id = #{@section.id}").first
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
		  
			flash[:success] = 'Sincronización realizada con éxito'

		if unenrolled.any?
			flash[:warning] = "Algunos estudiantes no están inscritos. Revise el área de las secciones para mayor detalle."
			
		end
		if unfinded.any?
			flash[:danger] = "Algunos estudiantes no fueron encontrados. Revise el área de las secciones para mayor detalle."
		end

		redirect_back fallback_location: '/admin/section'
	  end







	def delete
		course_period_id = @section.course_period_id
		
		if @section.destroy_section
			flash[:info] = 'Sección eliminada y estudiantes traladados a la sección 00'
		else
			flash[:danger] = "Error: #{@section.errors.full_messages.to_sentence}"
		end
		redirect_to "/admin/course_period/#{course_period_id}"

	end

	def unsplit
		course_period_id = @section.course_period_id
		begin
			errors, unenrolled, section_deleted = @section.destroy_section_on_canvas
			flash[:danger] = errors.to_sentence if errors.any?
			flash[:success] = "Estudiantes eliminados de la sección de Canvas: #{unenrolled}. Sección eliminada" if unenrolled > 0 and section_deleted			
		rescue Exception => e
			flash[:danger] = "Error: #{e}"
		end
		redirect_to "/admin/course_period/#{course_period_id}"
	end

	def split 

		begin
			number_split = params[:number_split].to_i
			total_groups = @section.academic_records.count/number_split
			remainder = @section.academic_records.count%number_split

			course_period = @section.course_period
			flash[:info] = ""
			total_new_sections = 0
			total_challenge = 0
			# canvas = MyCanvas.connect

			for i in 1..number_split
				new_section = @section.dup
				new_section.number = course_period.next_section_number
				if new_section.save
					# new_section.create_section_on_canvas canvas
					total_new_sections += 1
					@section.reload

					if remainder > 0
						aux = total_groups+1
						remainder -=1
					else
						aux = total_groups
					end
					@section.academic_records.limit(aux).each do |ar|
						ar.section = new_section
						total_challenge += 1 if ar.save
					end
					# new_section.reload
					course_period.reload
					# new_section.enrollments_to_canvas canvas
				else
					flash[:info] += "No fue posible crear la nueva sección: #{new_section.errors.full_messages.to_sentence}. "
				end
			end

			flash[:info] += "Se crearon un total de #{total_new_sections} nuevas secciones. "
			flash[:info] += "Se cambiaron de sección un total de #{total_challenge} estudiantes. "


		rescue Exception => e
			flash[:danger] = "Error al intentar distribuir las secciones: #{e}"
		end

		redirect_to "/admin/course_period/#{@section.course_period.id}"
	end

	def create_on_canvas
		begin
			if @section.create_section_on_canvas
				flash[:success] = "Sección creada en Canvas" 
			else
				flash[:danger] = "No se pudo crear la sección en Canvas"
			end
		rescue Exception => e
			flash[:danger] = "Error: #{e}"
		end
		redirect_back fallback_location: "/admin/section/#{@section.id}"
	end


	def enrollments_to_canvas
		begin
			flash[:success] = "Total asignados en Canvas: #{@section.enrollments_to_canvas}"
		rescue Exception => e
			flash[:danger] = "Error: #{e}"
		end
		redirect_back fallback_location: "/admin/section/#{@section.id}"
	end


	private
	  # Use callbacks to share common setup or constraints between actions.
	def set_section
		@section = Section.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	# def student_params
	# 	params.require(:student).permit(:personal_identity_document, :location, :source_country)
	# end

	# def section_params
	# 	params.require(:section).permit(:student_id, :section_id, ..... )
	# end

end

