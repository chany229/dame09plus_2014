# encoding: utf-8
module HomeHelper
	def remote?
		return session[:type] == 'jquery'
	end
end
