# encoding: utf-8
class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]
	layout "yamato_raven"
	def index
		#@users = User.all
		render :layout => false
	end

	def top
	end
end
