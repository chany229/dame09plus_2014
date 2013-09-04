# encoding: utf-8
class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]
	layout false

	def index
	end

	def frame
		render :layout => "yamato_raven"
	end

	def top
	end

	def logs
		@entries = Entry.desc(:created_at)
	end
end
