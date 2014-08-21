class OauthsController < ApplicationController

  before_filter :set_omniauth

  def use_provider

    if params[:iref]
      session[:iref] = URI.decode(params["iref"])
      session[:iref_locale] = params["locale"].to_s
    end

    redirect_to auth_path(params[:provider])
  end

  def create # when user comes backe

    @user = nil

    # @user = User.authenticatable.find_by_omniauth(@omniauth) #WTF???
    @oauth = Oauth.find_by_provider_and_uid(@omniauth["provider"], @omniauth["uid"])
    if @oauth and @oauth.user
      @user = @oauth.user
    end

    if !@user
      @user= User.find_by_email(@omniauth[:info][:email])
      if !@user # create new
        user_params = {
          :email => @omniauth[:info][:email]
        }


        @user = User.create_from_omniauth(@omniauth.except("extra"), user_params)

      end
    end

    authenticate_user(@user)

    if session[:iref]
      redirect_to session[:iref]
    else
      redirect_to user_path(@user.id)
    end

  end


  def destroy
    current_user.oauths.find_by_provider(params[:provider]).try(:destroy)
    redirect_to root_path, notice: "Disconnected"
  end

  def failure
    redirect_back_or_to root_path, alert: "Authentication failed"
  end

private

  def set_omniauth
    @omniauth = env["omniauth.auth"]
  end

end
