class ApplicationController < ActionController::Base
	helper_method :current_user, :authenticate_user
	before_action :all_users

	def current_user
		@user ||= User.find(session[:user_id]) if session[:user_id]
	end

	def authenticate_user
		if current_user.nil?
			redirect_to root_path
			flash[:alert] = "Must be logged in to continue!"
		end
	end

	private
	def error_message(errors)
		errors.full_messages.join(', ')
	end

	def all_users
		@users ||= User.all
	end
end 