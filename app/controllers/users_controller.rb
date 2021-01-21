class UsersController < ApplicationController
	before_action :set_user, except: [:index, :new, :create]
	before_action :authenticate_user!, except: [:update]
	before_action :setup_data, only: :update

	def registration_canvas
		status = @user.canvas_status
		if @user.update(canvas_email: @user.email)
			aux = 'Usuario Registrado en Canvas.'
			aux += ' Correo enviado al usuario.'if UserMailer.canvas_new_user_registration(@user, status).deliver
			flash[:success] = aux
		else
			flash[:danger] = 'Un error ha ocurrido intentando actualizar los datos del usuario, por favor verifique estos e inténtelo nuevamente.'
		end
		redirect_back fallback_location: '/admin/academic_record'
	end

	def update_canvas_email

		if @user.update(user_params)
			flash[:success] = "Email de Canvas actualizado con éxito"
		else
			flash[:danger] = "Error: #{@user.errors.full_messages.to_sentence}"
		end
		redirect_to student_session_index_path
	end
	def update
		# AVANCES EN EL AUTOREGISTRO EN CANVAS Y LA CONEXIÓN CON LA API
		# require 'canvas-api'
		# canvas = MyCanvas.connect

		# # main_account = canvas.get("/api/v1/accounts/#{ENV['CANVAS_ACCOUNT_ID']}/users")
		# main_account = canvas.get("/api/v1/sis_account_id/sis_account_id:self/users")

		# main_account = canvas.post("/api/v1/accounts/self/users", {user: {name: @user.full_name, short_name: @user.name, sortable_name: @user.last_name, terms_of_use: true}, pseudonym: {unique_id: @user.email, password: user_params[:password]}})
		# flash[:canvas] = main_account
		# user_canvas = canvas.post("/api/v1/accounts/#{ENV['CANVAS_ACCOUNT_ID']}/self_registration", {user: {name: @user.full_name, short_name: @user.name, sortable_name: @user.last_name, terms_of_use: true}, pseudonym: {unique_id: @user.email, password: user_params[:password]}})




		if @user.update(user_params)
				
			if student = @user.student and student_params
				if student.update(student_params)
					flash[:success] = "Datos del estudiante actualizados con éxito."
				else
					flash[:error] = student.errors.full_messages.to_sentence
				end
			elsif instructor = @user.instructor and instructor_params
				ba = instructor.bank_account				
				ba = BankAccount.new if ba.nil?

				ba.number = params[:bank_account][:number]
				ba.holder = "#{instructor.ci}-#{params[:bank_account][:number]}"
				ba.bank_id = params[:bank_account][:bank_id]
				ba.account_type = params[:bank_account][:account_type]
				if ba.save

					flash[:success] = "Datos de la cuenta actualizados con éxito."
					instructor.bank_account = ba
					if instructor.update(instructor_params)
						flash[:success] = "Datos del instructor actualizados con éxito."
					else
						flash[:error] = instructor.errors.full_messages.to_sentence
					end

				else
					flash[:error] = ba.errors.full_messages.to_sentence
				end
			end
		else
			flash[:error] = @user.errors.full_messages.to_sentence
		end
		redirect_back fallback_location: student_session_index_path
	end

	private
      # Use callbacks to share common setup or constraints between actions.
	def set_user
		@user = User.find(params[:id])
	end

	def setup_data
		params[:user][:number_phone] = "#{params[:operator_code]}#{params[:user][:number_phone]}" if (params[:user][:number_phone] and params[:operator_code])
		aux = params[:user][:sign_in_count].to_i
		params[:user][:sign_in_count] = aux+1 if (aux.eql? 0)
		params[:student][:source_country] = "Venezuela" if params[:student]
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def student_params
		params.require(:student).permit(:personal_identity_document, :location, :source_country) if params.require(:student)
	end

	def instructor_params
		params.require(:instructor).permit(:ci, :rif) if params.require(:instructor)
	end

	def user_params
		params.require(:user).permit(:name, :last_name, :email, :number_phone, :sign_in_count, :password, :password_confirmation, :canvas_email, :canvas_status)
	end

end
