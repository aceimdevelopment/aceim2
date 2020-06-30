class PaymentDetailsController < ApplicationController

	before_action :authenticate_user!

	before_action :set_payment_detail, only: [:confirm]

	def confirm
		ar = @payment_detail.academic_record

		if ar.preinscrito?
			ar.inscription_status = :confirmado
		elsif ar.confirmado?
			ar.inscription_status = :preinscrito
		end
		

		if ar.save
			type = 'success'
			msg = '¡Cambio realizado con éxito!'
		else
			type = 'danger'
			msg = 'No se puydo guardar el cambio.'
		end
      render json: {type: type, data: msg}, status: :ok

		
	end


	def new
		@payment_detail = PaymentDetail.new
		@academic_record = AcademicRecord.find params[:academic_record_id]
		@payment_detail.academic_record_id = @academic_record.id
		@user = current_user
	end

	def create
		begin
			data = payment_detail_params[:url_file]
			url = Rails.root.join('public', 'payment_receives', "payment_#{payment_detail_params[:academic_record_id]}.#{data.original_filename.split('.').last}")
			# data = data.tempfile
			File.open(url, "wb") do |file| 
				file.write(data.read) 
				# file.close
			end
		rescue Exception => e
			flash[:danger] = "Error: #{e.message}"
		end

		# params[:payment_detail][:url_file] = url
		@payment_detail = PaymentDetail.new(payment_detail_params)
		@payment_detail.url_file = url
		if @payment_detail.save
			flash[:success] = 'Se ha registrado su información de pago con éxito. Te invitamos a que estes atento a los cambios y confirmación de pago en estas, tu sesión de usuario de Aceim'
		else
			flash[:danger] = "No se pudo completar el guardado del reporte de pago. Por favor inténtalo de nuevo o concacta al personal calificado: #{@payment_detail.errors.full_messages.to_sentence}"
		end
		redirect_to student_session_index_path
	end

	private

	def set_academic_record
		@academic_record = AcademicRecord.find params[:academic_record_id]
	end

	def set_payment_detail
		@payment_detail = PaymentDetail.find params[:id]
	end

	def payment_detail_params
	params.require(:payment_detail).permit(:id, :created_at, :transaction_number, :mount, :source_bank_id, :bank_account_id, :academic_record_id, :transaction_type, :url_file)
	end

end
