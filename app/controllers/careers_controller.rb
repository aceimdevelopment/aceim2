class CareersController < ApplicationController
	before_action :set_carrer, only: [:constance, :constance_verify]
	before_action :authenticate_user!, except: [:constance_verify]

	layout 'pdf'

	def constance
		pdf = PdfDocs.constance(@career)
		unless send_data pdf.render, filename: "constancia#{@career.student.ci.to_s}-#{@career.language_id}.pdf", type: "application/pdf", disposition: "inline"
			flash[:error] = "En estos momentos no se pueden descargar el acta, intentelo más tarde."
		end
		return
	end

	def constance_verify
	end

	private

	def set_carrer
		@career = Career.find(params[:id])
	end

end
