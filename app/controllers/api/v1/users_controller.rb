class Api::V1::UsersController < Api::V1::ApiController
  before_filter :restrict_access, :only => [:update, :show]

  def create
    user = User.create(user_params)

    if user.valid?
      user.send_email_verification "en"
      create_mobile_device user
      render :json => {:success => true, :errors => user.errors.messages, user: user_mapped_values(user), authentication_token: user.create_auth_token}.to_json
    else
      render :json => {:success => false, :errors => user.errors.messages}.to_json
    end
  end

  def update
    @user.update_attributes(user_params)
    if @user.valid?
      render :json => {:success => true, :errors => @user.errors.messages, user: user_mapped_values(@user)}.to_json
    else
      render :json => {:success => false, :errors => @user.errors.messages}.to_json
    end
  end

  def show
    render :json => {:success => true, :user => user_mapped_values(@user)}
  end

private
  def user_params
    params.require(:user).permit(
      :email, :password, :name, :birthday, :sex, :latitude, :longitude, :accuracy, :phone
    )
  end

end
