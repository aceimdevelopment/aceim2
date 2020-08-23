class PaymentDetailsController < ApplicationController

	before_action :authenticate_user!

	before_action :set_payment_detail, only: [:confirm, :show, :read_report, :generate_pdf]

	def read_report
		if @payment_detail.update(read_report: true)
			flash[:success] = 'Recuerde que usamos CANVAS para sus clases y debe tener el mismo correo (gmail) registrado en ACEIM y en CANVAS. Por favor, escriba a fundeimucv@gmail.com si necesita apoyo con ese tema'
		end
	end


	def confirm
		ar = @payment_detail.academic_record

		if ar.preinscrito?				
			ar.inscription_status = :confirmado
		elsif ar.confirmado?
			ar.inscription_status = :preinscrito
		end

		if ar.save
			flash[:success] = '¡Cambio realizado con éxito!'
			

			begin
				if ar.section.period.enabled_autoregister_canvas_link and ar.confirmado? and UserMailer.autoenrollment_canvas(ar).deliver
					flash[:success] += 'Correo de automatriculación en Canvas enviado al estudiante.'
				end

				if PaymentDetailMailer.send_payment_confirmed(@payment_detail.id).deliver
					flash[:success] += ' Correo de pago enviado al estudiante.'
				else
					flash[:error] = "Problemas el intentar enviar el correo."
				end
			rescue Exception => e
				flash[:error] = "Problemas el intentar enviar el correo: #{e}."
			end			
			# type = 'success'
			# msg = '¡Cambio realizado con éxito!'
		else
			flash[:error] = 'No se puydo guardar el cambio. Por favor inténtelo de nuevo.'
			# type = 'danger'
			# msg = 'No se puydo guardar el cambio.'
		end

		# render json: {type: type, data: msg}, status: :ok
		redirect_back fallback_location: :index
	end


	def new
		@academic_record = AcademicRecord.find params[:academic_record_id]
		unless @academic_record.payment_detail.nil?
			flash[:error] = "Ya tienes un pago registrado para el curso seleccionado"
			redirect_to student_session_index_path
		else
			@payment_detail = PaymentDetail.new
			@payment_detail.academic_record_id = @academic_record.id
			@user = @academic_record.user
		end
	end

	def show
		@user = @payment_detail.user
		respond_to do |format|
			format.html


            # format.pdf do
            #     render pdf: "Invoice No. #{@payment_detail.id}",
            #     page_size: 'A4',
            #     template: "/payment_details/show.html.haml",
            #     layout: "pdf.html",
            #     orientation: "Landscape",
            #     lowquality: true,
            #     zoom: 1,
            #     dpi: 75
            # end

			format.pdf do 
				pdf = PdfDocs.bill_payment(@payment_detail)
				send_data pdf.render, filename: "factura_#{params[:id].to_s}.pdf", type: "application/pdf", disposition: "inline"
			end
		end
	end

	def create
		# begin
		# 	data = payment_detail_params[:url_file]
		# 	url = Rails.root.join('public', 'payment_receives', "payment_#{payment_detail_params[:academic_record_id]}.#{data.original_filename.split('.').last}")
		# 	# data = data.tempfile
		# 	File.open(url, "wb") do |file| 
		# 		file.write(data.read) 
		# 		# file.close
		# 	end
		# rescue Exception => e
		# 	flash[:danger] = "Error: #{e.message}"
		# end

		# params[:payment_detail][:url_file] = url
		@payment_detail = PaymentDetail.new(payment_detail_params)
		# @payment_detail.url_file = url
		if @payment_detail.save
			PaymentDetailMailer.send_payment_report(@payment_detail.id).deliver
			session[:payment_id] = @payment_detail.id #GeneralSetup.message_payment_report
		else
			flash[:error] = "No se pudo completar el guardado del reporte de pago. Por favor inténtalo de nuevo o concacta al personal calificado: #{@payment_detail.errors.full_messages.to_sentence}"
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
	params.require(:payment_detail).permit(:id, :created_at, :transaction_number, :mount, :source_bank_id, :bank_account_id, :academic_record_id, :transaction_type, :backup_file, :customer_name)
	end

end
