class ApplicationController < ActionController::Base
	# before_action :current_user
	before_action :all_users

	def current_user
		@user ||= User.find(session[:user_id]) if session[:user_id]
	end

	private
	def error_message(errors)
		errors.full_messages.join(', ')
	end

	def all_users
		@users ||= User.all
	end
end 