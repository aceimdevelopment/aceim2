class AcademicRecordsController < ApplicationController
	before_action :set_academic_record, only: [:show_payments_accounts, :certificate, :show]
	before_action :authenticate_user!

	def send_confirmation_mail
		if UserMailer.confirmation_enrollment_email(params[:id]).deliver
			flash[:success] = "¡Correo enviado con éxito!"
		else
			flash[:danger] = 'El correo no pudo ser enviado'
		end
		# if @academic_record
		# else
		# flash[:danger] = "Inscripción no encontrada"
		# end
		redirect_back fallback_location: rails_admin_path
	end

	# def show_payments_accounts
	# 	@academic_record
	# end

	def certificate
		pdf = PdfDocs.certificate(@academic_record)
		unless send_data pdf.render, filename: "planilla_inscripcion_#{params[:id].to_s}.pdf", type: "application/pdf", disposition: "inline"
			flash[:error] = "En estos momentos no se pueden descargar el acta, intentelo más tarde."
		end
		return
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
