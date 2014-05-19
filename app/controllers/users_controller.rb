# encoding: utf-8
class UsersController < ApplicationController
    #skip_before_filter :verify_authenticity_token, :only => [:upload_avatar]
    before_filter :authenticate_user!, :except => [:show]
    before_filter :get_user, :only => [:show]
    before_filter :get_current_user, :except => [:show]
    layout "devise"

    def show
    end

    def avatar
        render "upload_avatar"
    end

    def upload_avatar
        @user.avatar = File.new(params[:avatar][:path])
        @user.save

        #render "crop_avatar"
        redirect_to :action => :show, :id => @user.id
    end

    def crop_avatar
        @user.crop_x = params[:x]
        @user.crop_y = params[:y]
        @user.crop_w = params[:width]
        @user.crop_h = params[:height]

        @user.save

        redirect_to :action => :avatar
    end

    private

    def get_user
        @user = User.where(:username => params[:username]).first
    end

    def get_current_user
        @user = current_user
    end
end
