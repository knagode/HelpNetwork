class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params.merge(require_password: true, require_password_confirmation: true))
    respond_to do |format|
      if authenticate_user(@user)
        #stuff to do if user is authenticated
      end
      @errors = @user.errors
      if @errors.count > 0
        format.js
      else
        format.js { render js: %(Turbolinks.visit('#{user_path(@user.id)}')) }
      end
    end
  end

  def show

  end

private
  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation
    )
  end


end
