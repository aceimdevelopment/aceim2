class StudentSessionController < ApplicationController

	before_action :authenticate_user!
	
	def index
		if params[:id]
			@user =  User.find(params[:id])
		else
			@user = current_user
			session[:student] = @user.student
			if @user.student and @user.student.ci and !@user.student.imported?
				type, msg = @user.student.import_from_aceim
				flash[type] = msg
			end
		end
	end

	def regular_enrollment
		1/0
	end
end
