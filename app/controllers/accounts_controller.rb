class AccountsController < ApplicationController
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
        @user.path = params[:avatar]
        @user.save

        render "crop_avatar"
        #redirect_to :action => :show, :id => @user.username
    end

    def crop_avatar
        @user.update_attributes(params[:user])
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
