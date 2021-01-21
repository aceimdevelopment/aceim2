class InstructorSessionController < ApplicationController

	before_action :authenticate_user!
	before_action :set_user_session, only: :index
	
	def index
		@instructor = @user.instructor
		session[:user_id] = @user.id if params[:simulated]
	end

	def show_sections
		@section = Section.find params[:id]
		@user = User.find session[:user_id] if session[:user_id]
	end

	private

	def set_user_session
		if params[:id]
			instructor =  Instructor.find(params[:id])
			@user =  instructor.user
		elsif session[:user_id]
			@user = User.find session[:user_id]
		else
			@user = current_user
		end
	end	
end
