class ApplicationController < ActionController::Base
	# protect_from_forgery with: :null_session


	protect_from_forgery with: :exception

  	before_action :authenticate_user!

	# def after_sign_up_path_for(resource)
	# 	1/0
	# 	# if param[:student]

	# 	student_session_index_path
	# end

	def longged_in
		respond_to :json
		respond_with user_signed_in?
	end


	def after_sign_in_path_for(resource)
		# dashboard_index_path
		roles = []
		roles << :administrador if current_user.administrator
		roles << :student if current_user.student
		roles << :instructor if current_user.instructor

		if roles.count > 1
			params[:roles] = roles
			select_role_home_index_path(roles: roles)
		elsif current_user.administrator?
			rails_admin_path
		elsif current_user.student?
			student_session_index_path
		elsif current_user.instructor?
			instructor_session_index_path
		else
			flash[:warning] = "No posee rol asignado. Por favor diríjase a un Administrador para cambiar dicha situación"
			root_path 
		end
	end

end
