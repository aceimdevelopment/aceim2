class PeriodsController < ApplicationController

	before_action :authenticate_user!
	before_action :set_period, only: :onoff_switch

	def onoff_switch
		case params[:function_to_switch]
		when 'canvas_autoregister' 
			@period.enabled_autoregister_canvas_link = !@period.enabled_autoregister_canvas_link

			@period.academic_records.confirmado.each do |ar|
				UserMailer.autoenrollment_canvas(ar).deliver
			end
		when 'canvas_login' 
			@period.enabled_login_canvas_link = !@period.enabled_login_canvas_link
		when 'enrollment'
			@period.enrollment = !@period.enrollment
		end

		if @period.save
			type = 'success'
			msg = '¡Cambio realizado con éxito!'
		else
			type = 'danger'
			msg = 'No se puydo guardar el cambio.'
		end

      # head :no_content
      render json: {type: type, data: msg}, status: :ok

	end

	private

	def set_period
		@period = Period.find(params[:id])
	end
end
