class SessionsController < ApplicationController

  def new

  end

  def create
    @errors = ActiveModel::Errors.new(nil)

    email  = user_params[:email]
    password = user_params[:password]

    if !@user = User.find_by_email(email)
      @errors.add(:email, "No user with email")
    elsif !@user.authenticate(password)
      @errors.add(:password, "Wrong email or password")
    end

    if !authenticate_user(@user)
      @errors.add(:email, "User not authenticatable")
    end

    respond_to do |format|
      if @errors.any?
        format.js
      else
        format.js { render js: %(Turbolinks.visit('#{user_path(:id => @user.id)}')) }
      end
    end
  end

  def destroy
    unauthenticate

    redirect_to login_path, :notice => "You have been logged out"
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :remember)
    end

end
