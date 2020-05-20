class HomeController < ApplicationController
	skip_before_action :authenticate_user!, :only => [:index]
	layout 'home'
	def index
	end
end
