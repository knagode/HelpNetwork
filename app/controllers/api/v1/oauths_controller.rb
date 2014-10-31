class Api::V1::OauthsController < Api::V1::ApiController

  def create
    require 'open-uri'
    errors = ActiveModel::Errors.new(nil);
    provider = oauth_params[:provider]
    if provider == "facebook" || provider == "google"
      url = ""
      if provider == "facebook"
        url = "https://graph.facebook.com/me?access_token="
      elsif provider == "google"
        url = "https://www.googleapis.com/oauth2/v2/userinfo?access_token="
      end

      #Assign the return value or catch the error and return it
      if Rails.env.test?
        require 'json'
        if "facebook" == provider
          content = {:email => "test@test.com", :uid => "123123", :name => "Marko", :first_name => "Marko", :last_name => "test", :gender => "male", :birthday => "7-7-2014"}.to_json
        else
          content = {:email => "test@test.com", :uid => "123123", :name => "Marka test", :first_name => "Marka", :last_name => "test", :gender => "female", :birthday => ""}.to_json
        end
        status = '200'
      else
        begin
          content = open(URI.encode(url + oauth_params[:token]))
        rescue OpenURI::HTTPError
          errors.add(:token, t('oauths.wrong_or_expired_access_token'))
        end
      end

      if !content
        errors.add(:provider, t('oauths.response_not_defined'))
        return render :json => {:success => false, :errors => errors }.to_json
      end

      if !Rails.env.test?
        status  = content.status[0]
      end
      content = JSON.load(content)

      profile_picture = ""
      if provider == "facebook"
        profile_picture = "http://graph.facebook.com/"+content["id"]+"/picture?type=square".to_s
      elsif "google" == provider
        profile_picture = content['picture']
      end

      email   = content['email']
      uid = content['id']

      create_new_user = false

      if status != '200'
        errors.add(:provider, t('oauths.provider_error_after_connection'))
      elsif @oauth = Oauth.find_by_provider_and_uid(provider,uid)
        @user = @oauth.user
        #oauth has no user
        if !@user
          create_new_user = true
          @oauth.delete
        else
          @user.picture = profile_picture
          @user.save!
        end

      elsif @user = User.find_by_email(email)
        #user exists, create oauth
        Oauth.create(:provider => provider, :uid => uid, :user => @user)
      else #create new user
        create_new_user = true
      end

      if create_new_user
        @user = User.new
        @user.picture = profile_picture
        @user.email           = email
        @user.name            = content['name']
        @user.firstname      = content['first_name']
        @user.lastname       = content['last_name']
        @user.email_verified_at = Time.zone.now
        @user.email_verified = true
        if content['gender'] == "female"
          @user.sex = 1
        else
          @user.sex = 0
        end

        if (content['birthday']) && !(content['birthday'].blank?)
          @user.birthday         = content['birthday']
        else
          @user.birthday         = "1-1-1980"
        end

        #Set a password to the user, maybe we will send it to the user later
        @user.password = SecureRandom.urlsafe_base64
        @user.password_confirmation = @user.password

        if !@user.save
          @user.errors.messages.each do |k,v|
            errors.add(k, v)
          end
        else
          Oauth.create(:provider => provider, :uid => uid, :user => @user)
        end
      end
    else
      errors.add(:provider, t('oauths.only_fb_and_google_permitted'))
    end

    if errors.any?
      render :json => {:success => false, :errors => errors }.to_json
    else
      create_mobile_device @user
      render :json => {:success => true, :errors => errors, :authentication_token => @user.create_auth_token, user: user_mapped_values(@user) }.to_json
    end
  end

  private
    def oauth_params
      params.require(:oauth).permit(:provider, :token)
    end

    def user_params
      params.require(:user).permit(
        :email, :password, :name, :birthday, :sex
      )
    end

end
