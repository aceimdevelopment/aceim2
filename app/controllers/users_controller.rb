class UsersController < ApplicationController
	before_action :set_user, except: [:index, :new, :create]
	before_action :authenticate_user!
	before_action :setup_data, only: :update
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
			student = @user.student	
			if student_params and student
				if student.update(student_params)
					flash[:success] = "Usuario actualizado con éxito"
					# if @user.id_canvas.blank?
					# 	begin
					# 		canvas = MyCanvas.connect
					# 		user_canvas = canvas.post("/api/v1/accounts/#{ENV['CANVAS_ACCOUNT_ID']}/self_registration", {user: {name: @user.full_name, short_name: @user.name, sortable_name: @user.last_name, terms_of_use: true}, pseudonym: {unique_id: @user.email, password: user_params[:password]}})

					# 		@user.id_canvas = user_canvas['id'] if user_canvas['id']

					# 		flash[:success] = "Usuario actualizado con éxito. Agregaado a Canvas." if @user.save 

					# 	rescue Exception => e
					# 		flash[:error] = "Problemas en Canvas: #{e}"
					# 	end
					# end
				else
					flash[:error] = student.errors.full_messages.to_sentence
				end
			end
		else
			flash[:error] = @user.errors.full_messages.to_sentence
		end


		redirect_to student_session_index_path
	end

	private
      # Use callbacks to share common setup or constraints between actions.
	def set_user
		@user = User.find(params[:id])
	end

	def setup_data
		params[:user][:number_phone] = "#{params[:oparator_code]}#{params[:user][:number_phone]}"
		aux = params[:user][:sign_in_count].to_i
		params[:user][:sign_in_count] = aux+1
		params[:student][:source_country] = "Venezuela"
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def student_params
		params.require(:student).permit(:personal_identity_document, :location, :source_country)
	end

	def user_params
		params.require(:user).permit(:name, :last_name, :email, :number_phone, :sign_in_count, :password, :password_confirmation)
	end

end
