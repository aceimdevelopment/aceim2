class StudentSessionController < ApplicationController

	before_action :authenticate_user!
	before_action :set_user_session, only: [:index, :multimedia]
	
	def index
		if @user.student and @user.student.ci and !@user.student.imported?
			type, msg = @user.student.import_from_aceim_local
			flash[type] = msg
		end
		session[:student] = true #IMPORTANTE: Esta variable es para tomar en cuenta los casos de multiples roles 
		session[:user_id] = @user.id if params[:simulated]
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
			student =  Student.find(params[:id])
			@user =  student.user
		elsif session[:user_id]
			@user = User.find session[:user_id]
		else
			@user = current_user
		end
	end
end
