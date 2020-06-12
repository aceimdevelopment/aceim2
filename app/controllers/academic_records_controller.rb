class AcademicRecordsController < ApplicationController
	before_action :set_academic_record, except: [:index, :new, :create]
	before_action :authenticate_user!

	def send_confirmation_mail
		if @academic_record
			if UserMailer.confirmation_enrollment_email(@academic_record).deliver
				flash[:success] = "¡Correo enviado con éxito!"
			else
				flash[:danger] = 'El correo no pudo ser enviado'
			end
		else
			flash[:danger] = "Inscripción no encontrada"
		end
		redirect_back fallback_location: rails_admin_path
	end

	private

      # Use callbacks to share common setup or constraints between actions.
	def set_academic_record
		@academic_record = AcademicRecord.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	# def student_params
	# 	params.require(:student).permit(:personal_identity_document, :location, :source_country)
	# end

	# def academic_record_params
	# 	params.require(:academic_record).permit(:student_id, :section_id, ..... )
	# end

end
