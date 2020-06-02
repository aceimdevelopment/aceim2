class UsersController < ApplicationController
	before_action :set_user, except: [:index, :new, :create]
	before_action :authenticate_user!
	before_action :setup_data, only: :update
	def update
		# user_params['number_phone'] = "#{params[:oparator_code]}#{user_params['number_phone']}"
		# user_params['sign_in_count'] = @user.sign_in_count + 1
		if @user.update(user_params)
			student = @user.student	
			if student_params and student
				if student.update(student_params)
					flash[:success] = "Usuario actualizado con éxito"
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
		params.require(:user).permit(:name, :last_name, :email, :number_phone, :sign_in_count)
	end

end
