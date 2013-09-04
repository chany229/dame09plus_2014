# encoding: utf-8
module HomeHelper
	def remote?
		return session[:format] != 'html'
	end
end
