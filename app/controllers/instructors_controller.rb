class InstructorsController < ApplicationController
	before_action :set_instructor#, only: [:constance, :constance_verify]
	before_action :authenticate_user!, except: [:work_proof_verify]

	layout 'pdf'

	def work_proof
		pdf = PdfDocs.get_work_proof(@instructor)
		unless send_data pdf.render, filename: "constancia#{@instructor.ci.to_s}.pdf", type: "application/pdf", disposition: "inline"
			flash[:error] = "En estos momentos no se pueden descargar el acta, intentelo más tarde."
		end
		return
	end

	def work_proof_verify
	end

	private

	def set_instructor
		@instructor = Instructor.find(params[:id])
	end

end
