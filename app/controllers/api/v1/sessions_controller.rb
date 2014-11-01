class Api::V1::SessionsController < Api::V1::ApiController

  def create
    errors = ActiveModel::Errors.new(nil)

    email  = user_params[:email]
    password = user_params[:password]

    if !@user = User.find_by_email(email)
      errors.add(:email, t('users.no_user_with_email'))
    elsif !@user.authenticate(password)
      errors.add(:password, t('users.wrong_email_or_password'))
    end

    if @user && !@user.email_verified?
      errors.add(:user, t('users.not_verified'))
    end

    if errors.any?
      render :json => {:success => false, :errors => errors }.to_json
    else
      create_mobile_device @user
      render :json => {:success => true, :errors => errors, :authentication_token => @user.create_auth_token, user: user_mapped_values(@user) }.to_json
    end
  end


private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
