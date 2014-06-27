# encoding: utf-8
require 'rqrcode'
class HomeController < ApplicationController
	#before_filter :authenticate_user!, :except => [:index]
	before_filter :check_from_angular, :except => [:index, :frame, :calendar]
	layout :get_layout

	def index
		@qr = RQRCode::QRCode.new('http://dame09.com')
		render :layout => false
	end

	def frame
=begin
		if params[:type]
			session[:type] = cookies[:type] = params[:type]
		elsif cookies[:type]
			session[:type] = cookies[:type]
		else
			session[:type] = cookies[:type] = "angular"
		end
=end
		#render :layout => "yamato_raven"
	end

	def top
	end
	
	def profile
	end

	def links
	end

	def logs
		respond_to do |format|
			format.html {
				@entries = Entry.desc(:created_at).page(params[:page] || 1).per(5)
				@filter  = "全部"
				@tags = Entry.all_tags
				@calendar_date = Time.now
				@calendar_events = Entry.where(:created_at => @calendar_date.beginning_of_month..@calendar_date.end_of_month).map{ |e| e.created_at.day }.uniq

				@page_hash = "#/logs"
			}
			format.js {
				@hash = "#/logs/p#{params[:page] || 1}"
				render 'search.js.erb'
			}
		end
	end

	def tag
		tag      = params[:tag_name]
		respond_to do |format|
			format.html {
				@entries = Entry.tagged_with(tag).desc(:created_at).page(params[:page] || 1).per(5)
				@filter  = "标签[#{tag}]"
				@calendar_date = Time.now
				@calendar_events = Entry.where(:created_at => @calendar_date.beginning_of_month..@calendar_date.end_of_month).map{ |e| e.created_at.day }.uniq
				@tags = Entry.all_tags

				@page_hash = "#/logs/tag/#{tag}"
				render :action => :logs
			}
			format.js {
				@hash = "#/logs/tag/#{tag}/p#{params[:page] || 1}"
				render 'search.js.erb'
			}
		end
	end

	def tags
		tags = params[:tags].split('|')
		type = params[:type]
		respond_to do |format|
			format.html {
				if type.downcase == 'and'
					@entries = Entry.tagged_with_all(tags).desc(:created_at).page(params[:page] || 1).per(5)
					@filter  = "标签与搜索[#{params[:tags]}]"
				else#if type.downcase == 'or'
					@entries = Entry.tagged_with(tags).desc(:created_at).page(params[:page] || 1).per(5)
					@filter  = "标签或搜索[#{params[:tags]}]"
				end
				@calendar_date = Time.now
				@calendar_events = Entry.where(:created_at => @calendar_date.beginning_of_month..@calendar_date.end_of_month).map{ |e| e.created_at.day }.uniq
				@tags = Entry.all_tags


				@page_hash = "#/logs/tags/#{type}-#{params[:tags]}"
				render :action => :logs
			}
			format.js {
				@hash = "#/logs/tags/#{type}-#{params[:tags]}/p#{params[:page] || 1}"
				render 'search.js.erb'
			}
		end
	end		

	def keyword
		keyword  = params[:keyword]
		respond_to do |format|
			format.html {
				@entries = Entry.or({:short => /#{keyword}/}, {:long => /#{keyword}/}).desc(:created_at).page(params[:page] || 1).per(5)
				@filter  = "关键词[#{keyword}]"
				@calendar_date = Time.now
				@calendar_events = Entry.where(:created_at => @calendar_date.beginning_of_month..@calendar_date.end_of_month).map{ |e| e.created_at.day }.uniq
				@tags = Entry.all_tags


				@page_hash = "#/logs/keyword/#{keyword}"
				render :action => :logs
			}
			format.js {
				@hash = "#/logs/keyword/#{keyword}/p#{params[:page] || 1}"
				render 'search.js.erb'
			}
		end
	end

	def date
		now      = Time.now
		@year    = params[:year]  || now.year
		@month   = params[:month] || now.month
		@day     = params[:day]   || now.day
		if params[:day]
			time = Time.new(@year, @month, @day)
			start_time = time.beginning_of_day
			end_time = time.end_of_day
			@filter = "#{@year}年#{@month}月#{@day}日"
			@page_hash = "#/logs/#{@year}-#{@month}-#{@day}"
		elsif params[:month]
			time = Time.new(@year, @month, 1)
			start_time = time.beginning_of_month
			end_time = time.end_of_month
			@filter = "#{@year}年#{@month}月"
			@page_hash = "#/logs/#{@year}-#{@month}"
		elsif params[:year]
			time = Time.new(@year, 1, 1)
			start_time = time.beginning_of_year
			end_time = time.end_of_year
			@filter = "#{@year}年"
			@page_hash = "#/logs/#{@year}"
		else
			redirect_to '#/logs'
			return
		end
		@hash = "#{@page_hash}/p#{params[:page] || 1}"
		respond_to do |format|
			format.html {
				@entries = Entry.where(:created_at => start_time..end_time).desc(:created_at).page(params[:page] || 1).per(5)
				@calendar_date = time
				Rails.logger.info @calendar_date.month.to_s + " <= month !!!!!!!!!!!!!!"
				@calendar_events = Entry.where(:created_at => @calendar_date.beginning_of_month..@calendar_date.end_of_month).map{ |e| e.created_at.day }.uniq
				@tags = Entry.all_tags
				render :action => :logs
			}
			format.js {
				render 'search.js.erb'
			}
		end
	end
	def calendar
		@date = Time.at(params[:date].to_i)
		@events = Entry.where(:created_at => @date.beginning_of_month..@date.end_of_month).map{ |e| e.created_at.day }.uniq
		respond_to do |format|
			format.js
		end
	end

	def create_comment
		@entry = Entry.where(:id => params[:entry_id]).first
		@comment = @entry.comments.new(params[:comment])
		if current_user
			@comment.user = current_user
		else
			session[:username] = cookies[:username] = params[:comment][:username]
		end
		@comment.save
		session[:comment_color] = cookies[:comment_color] = params[:comment][:comment_color]
		respond_to do |format|
			format.js
		end
	end

	def remove_comment
		result = false
		if current_user
			@entry = Entry.where(:id => params[:entry_id]).first
			@comment = @entry.comments.find(params[:comment_id])
			if current_user.has_role?(:admin) or current_user == @comment.user
				result = @comment.destroy
			end
		end
		Rails.logger.info result
		respond_to do |format|
			format.js
		end
	end


	private

	def get_layout
		if params[:from_angular]
			return false
		else
			return params[:skin] || session[:skin] || "flowers" || "yamato_raven"
		end
	end

	def check_from_angular
		unless params[:from_angular]
			session[:type] = "jquery"
		end
	end
end
