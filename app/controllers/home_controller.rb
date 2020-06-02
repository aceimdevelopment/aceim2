class HomeController < ApplicationController
	skip_before_action :authenticate_user!, :only => [:index]
	layout 'home'
	def index
		session.clear
	end

	def select_role
		@roles = params[:roles]
	end
end
