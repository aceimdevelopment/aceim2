class PeriodsController < ApplicationController

	before_action :authenticate_user!
	before_action :set_period, only: :onoff_switch

	def onoff_switch
		@period.enabled_autoregister_canvas_link = !@period.enabled_autoregister_canvas_link if params[:function_to_switch].eql? 'canvas_autoregister'
		@period.enabled_login_canvas_link = !@period.enabled_login_canvas_link if params[:function_to_switch].eql? 'canvas_login'

		if @period.save
			type = 'success'
			msg = '¡Cambio realizado con éxito!'
		else
			type = 'danger'
			msg = 'No se puydo guardar el cambio.'
		end

      head :no_content

	end

	private

	def set_period
		@period = Period.find(params[:id])
	end
end
