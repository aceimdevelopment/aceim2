class QualificationSchemasController < ApplicationController

	before_action :authenticate_user!
	before_action :set_qualification_schema

	def onoff_switch
		@qs.enabled = !@qs.enabled

		if @qs.save
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

	def set_qualification_schema
		@qs = QualificationSchema.find(params[:id])
	end
end
