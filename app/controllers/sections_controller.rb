class SectionsController < ApplicationController
	before_action :set_section, except: [:index, :new, :create]
	before_action :authenticate_user!

	def split 
		number_split = params[:number_split].to_i
		total_groups = @section.academic_records.count/number_split
		remainder = @section.academic_records.count%number_split

		flash[:info] = ""
		total_new_sections = 0
		total_challenge = 0
		for i in 1..number_split-1
			section_aux = @section.dup
			section_aux.number = @section.course_period.next_section_number

			if section_aux.save
				total_new_sections += 1
				@section.reload
				if remainder > 0
					aux = total_groups+1
					remainder -=1
				else
					aux = total_groups
				end
				@section.academic_records.limit(aux).each do |ar|
					ar.section = section_aux
					total_challenge += 1 if ar.save
				end
			else
				flash[:info] += "No fue posible crear la nueva sección #{section_aux.errors.full_messages.to_sentence}"
			end
		end

		flash[:info] += "Se crearon un total de #{total_new_sections} nuevas secciones"
		flash[:info] += "Se cambiaron de sección un total de #{total_challenge} estudiantes"

		redirect_back fallback_location: rails_admin_path
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

