class SectionsController < ApplicationController
	before_action :set_section, except: [:index, :new, :create]
	before_action :authenticate_user!

	def split 

		begin
			number_split = params[:number_split].to_i
			total_groups = @section.academic_records.count/number_split
			remainder = @section.academic_records.count%number_split

			course_period = @section.course_period
			flash[:info] = ""
			total_new_sections = 0
			total_challenge = 0
			canvas = MyCanvas.connect

			for i in 1..number_split-1
				new_section = @section.dup
				new_section.number = course_period.next_section_number
				if new_section.save
					
					new_section.create_section_on_canvas canvas
					
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
					new_section.reload
					new_section.enrollments_to_canvas canvas
				else
					flash[:info] += "No fue posible crear la nueva sección #{new_section.errors.full_messages.to_sentence}"
				end
			end

			if @section.id_canvas.nil?
				@section.create_section_on_canvas canvas
				@section.enrollments_to_canvas canvas
			end

			flash[:info] += "Se crearon un total de #{total_new_sections} nuevas secciones"
			flash[:info] += "Se cambiaron de sección un total de #{total_challenge} estudiantes"


		rescue Exception => e
			flash[:danger] = "Error al intentar distribuir las secciones: #{e}"
		end

		redirect_back fallback_location: rails_admin_path
	end


	def enrollments_to_canvas
		begin
			flash[:success] = "Total asignados en Candas: #{@section.enrollments_to_canvas}"	
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

