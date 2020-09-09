class PeriodsController < ApplicationController

	before_action :authenticate_user!
	before_action :set_period

	def clean_not_reported
		ids = @period.academic_records.preinscrito.reject{ |ar| ar.payment_detail}.map{ |ar| ar.id }
		total = ids.count
		if total > 0
			if	AcademicRecord.where("id IN (?)", ids).destroy_all
				flash[:info] = "#{total} registros de preinscripciones sin reporte de pago"
			else
				flash[:danger] = "Error al intentar eliminar preinscripciones. Por favor inténtelo nuevamente"
			end
		else
			flash[:info] = "Sin registros por eliminar"
		end

		redirect_back fallback_location: '/admin/period'
	end

	def onoff_switch
		case params[:function_to_switch]
		when 'canvas_autoregister' 
			@period.enabled_autoregister_canvas_link = !@period.enabled_autoregister_canvas_link
		when 'canvas_login' 
			@period.enabled_login_canvas_link = !@period.enabled_login_canvas_link
		when 'enrollment'
			@period.enrollment = !@period.enrollment
		when 'enabled_qualification'
			@period.enabled_qualification = !@period.enabled_qualification
		when 'show_survey'
			@period.show_survey = !@period.show_survey
		end

		if @period.save
			if params[:function_to_switch].eql? 'canvas_autoregister' and @period.enabled_autoregister_canvas_link
				@period.academic_records.confirmado.each do |ar|
					UserMailer.autoenrollment_canvas(ar).deliver
				end
			end
			type = 'success'
			msg = '¡Cambio realizado con éxito!'
		else
			type = 'danger'
			msg = 'No fue posible realizar el cambio solicitado.'
		end

      # head :no_content
      render json: {type: type, data: msg}, status: :ok

	end

	private

	def set_period
		@period = Period.find(params[:id])
	end
end
