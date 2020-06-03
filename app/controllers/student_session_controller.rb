class StudentSessionController < ApplicationController

	before_action :authenticate_user!
	
	def index
	end

	def regular_enrollment
		1/0
	end
end
