class Api::V1::ApiController < ActionController::Base
  respond_to :json
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  before_filter :set_locale, :except => [:send_alerts]


  def set_locale
    @current_locale = :en
    # begin
    #   if language_params.has_key?(:locale)
    #     tmp_locale = :en

    #     if I18n.available_locales.include?(language_params[:locale].to_sym)
    #       tmp_locale = language_params[:locale]
    #     end
    #     I18n.locale = tmp_locale
    #     @current_locale = tmp_locale
    #   else
    #     errors = ActiveModel::Errors.new(nil)
    #     errors.add(:language, t('api.locale_not_set'))
    #     return render :json => {:success => false, :errors => errors}.to_json
    #   end
    # rescue ActionController::ParameterMissing
    #   errors = ActiveModel::Errors.new(nil)
    #   errors.add(:language, t('api.parameter_missing'))
    #   return render :json => {:success => false, :errors => errors}.to_json
    # end

  end

  # custom exception handling
  rescue_from Exception do |e|
    respond_with(@switches) do |format|
      format.html { raise e } # default operation
      format.json { error(e) }
    end
  end

  def create_mobile_device user
    mobile_device = MobileDevice.new(mobile_device_params)
    mobile_device.user = user
    mobile_device.save!
  end

  def user_mapped_values user
    return {:birthday => user.birthday, :sex => user.sex, :email => user.email, :firstname => user.firstname, :lastname => user.lastname, :name => user.name}
  end




  protected

   def error(e)
      #render :template => "#{Rails::root}/public/404.html"
      if env["ORIGINAL_FULLPATH"] =~ /^\/api/
      error_info = {
        # :success => false,
        :error => "#{e.class.name}",
        :error_description => "#{e.message}"
      }
      #we dont need the trace...if there is a big problem, get the trace too
      error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
      render :json => error_info.to_json
      else
        #render :text => "500 Internal Server Error", :status => 500 # You can render your own template here
        raise e
      end
  end

  private
    def restrict_access
      authentication_token = AuthenticationToken.find_by_user_id_and_token(authentication_token_params[:user_id], authentication_token_params[:token])
      if !@authentication_token
        return head :unauthorized unless authentication_token
      end
      @user = authentication_token.user
      head :unauthorized unless @user
    end

    def authentication_token_params
      params.require(:authentication_token).permit(:token, :user_id)
    end

    def mobile_device_params
      params.require(:mobile_device).permit(:model, :system_name, :system_version, :multitasking, :push_notification_token)
    end

    def language_params
      params.require(:language).permit(:locale)
    end

    def vehicle_short_params
      params.require(:vehicle).permit(:id)
    end

end
