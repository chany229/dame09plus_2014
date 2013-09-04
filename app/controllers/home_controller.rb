# encoding: utf-8
class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]
	layout false

	def index
		#@users = User.all
	end

	def frame
		render :layout => "yamato_raven"
	end

	def top
	end
end
