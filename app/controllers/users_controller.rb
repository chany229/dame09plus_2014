# encoding: utf-8
class UsersController < ApplicationController
    before_filter :authenticate_user!, :except => [:show]
    before_filter :get_user
    layout "devise"

    def show
    end

    def avatar
    end

    def crop_avatar
        @user.crop_x = params[:x]
        @user.crop_y = params[:y]
        @user.crop_w = params[:width]
        @user.crop_h = params[:height]

        @user.save!

        redirect_to :action => :avatar, :username => params[:username]
    end

    private

    def get_user
        @user = User.where(:username => params[:username]).first
    end

end
