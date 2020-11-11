class StudentSessionController < ApplicationController

	before_action :authenticate_user!
	before_action :set_user_session, only: [:index, :multimedia]
	
	def index
		if @user.student and @user.student.ci and !@user.student.imported?
			type, msg = @user.student.import_from_aceim_local
			flash[type] = msg
		end
	end

	def multimedia
		@title = 'Contenido Multimendia'
	end

	def regular_enrollment
		1/0
	end

	private

		def set_user_session
			if params[:id]
				@user =  User.find(params[:id])
			else
				@user = current_user
				session[:student] = @user.student
			end		
		end
end
