class SetupController < ApplicationController

  def step_2

  end

  def finished

  end

private
  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation
    )
  end


end
