# encoding: utf-8
class ApplicationController < ActionController::Base
	protect_from_forgery

	def check_admin_permission
		unless current_user.has_role? :admin
			redirect_to root_path
		end
	end
end
