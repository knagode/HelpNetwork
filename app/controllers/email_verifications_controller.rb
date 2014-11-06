class EmailVerificationsController < ApplicationController


  def update

    @user = User.authenticatable.find_by_email_verification_token!(params[:id])
    if @user.email_verified?
      redirect_to root_path, alert: t('ajax_messages.email_verification_verified')
    elsif @user.try(:email_verification_expired?)
      redirect_to root_path, alert: t('ajax_messages.email_verification_expired')
    elsif @user.try(:verify_email!)
      redirect_to root_path, notice: t('ajax_messages.email_verified')
    end
  end


end
