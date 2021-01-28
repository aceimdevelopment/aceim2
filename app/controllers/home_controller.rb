class HomeController < ApplicationController
	skip_before_action :authenticate_user!, only: [:index,:longged_in]
	def index
		session.clear
	end

	def longged_in
		render json: user_signed_in?
	end

	def show
		@roles = params[:id]
	end
end
