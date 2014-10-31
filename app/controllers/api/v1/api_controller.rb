class Api::V1::ApiController < ActionController::Base
  respond_to :json
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  before_filter :set_locale, :except => [:send_alerts]

  def send_alerts
    alerts = Alert.unsent_push_notifications

    alerts.each do |alert|
      alert.send_notification!
    end
    puts "Send alert"

    render :json => {:success => true}.to_json
  end

  def set_locale
    begin
      if language_params.has_key?(:locale)
        tmp_locale = :en

        if I18n.available_locales.include?(language_params[:locale].to_sym)
          tmp_locale = language_params[:locale]
        end
        I18n.locale = tmp_locale
        @current_locale = tmp_locale
      else
        errors = ActiveModel::Errors.new(nil)
        errors.add(:language, t('api.locale_not_set'))
        return render :json => {:success => false, :errors => errors}.to_json
      end
    rescue ActionController::ParameterMissing
      errors = ActiveModel::Errors.new(nil)
      errors.add(:language, t('api.parameter_missing'))
      return render :json => {:success => false, :errors => errors}.to_json
    end

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
    return {:birthday => user.birthday, :sex => user.sex, :email => user.email, :firstname => user.firstname, :lastname => user.lastname, :name => user.name, :picture => user.picture}
  end

  def mapped_event_enriched_values ee
    return {:user_mode => @user.user_modes.last.nice_id, :id => ee.id, :device_id => ee.device_id, :ts => ee.ts, :obd_coolant_temperature => ee.obd_coolant_temperature, :obd_rpm => ee.obd_rpm,
      :obd_manifold_pressure => ee.obd_manifold_pressure, :obd_speed => ee.obd_speed, :obd_air_flow_rate => ee.obd_air_flow_rate, :obd_throttle => ee.obd_throttle, :obd_fuel_level => ee.obd_fuel_level,
      :obd_vin => ee.obd_vin, :obd_current_dtcs => ee.obd_current_dtcs, :obd_pending_dtcs => ee.obd_pending_dtcs, :obd_permanent_dtcs => ee.obd_permanent_dtcs, :obd_engine_state => ee.obd_engine_state,
      :obd_intake_temperature => ee.obd_intake_temperature, :obd_engine_load => ee.obd_engine_load, :lon => ee.lon, :alt => ee.alt, :lat => ee.lat, :gps_sats_used => ee.gps_sats_used,
      :gps_course => ee.gps_course, :gps_speed => ee.gps_speed, :core_power_state => ee.core_power_state, :road_country => ee.road_country, :road_place => ee.road_place, :road_name => ee.road_name,
      :road_type => ee.road_type, :road_max_speed => ee.road_max_speed, :current_location_unknown => ee.current_location_unknown, :last_location_ts => ee.last_location_ts, :json_raw => ee.json_raw,
      :created_at => ee.created_at, :updated_at => ee.updated_at}
  end

  def mapped_user_alert (al, ua)
    if "geofence_point" == ua.key
      return {:id => ua.id, :key => ua.key, :ts => al.ts, :value => ua.value, :read_at => al.read_at, :description => "asd bobidy bu geofence"}
    elsif "follow_request" == ua.key
      ts = 0
      read_at = nil
      if al
        ts = al.ts
        read_at = al.read_at
      end
      return {:id => ua.id, :key => ua.key, :ts => ts, :value => {:accepted => ua.value["accepted"], :accepted_at => ua.value["accepted_at"],:following => User.find(ua.value["following_id"]), :follower => User.find(ua.value["follower_id"])}, :read_at => read_at, :description => "Bibidy bobidy bu follow request" }
    else
      return {:id => ua.id, :key => ua.key, :ts => al.ts, :value => ua.value, :read_at => al.read_at, :description => "key not supported" }
    end
  end

  def vehicle_if_user_can_access_vehicle_with_id (user_id, vehicle_id)
    begin
      vehicle = Vehicle.find(vehicle_id)
    rescue ActiveRecord::RecordNotFound
      return nil
    end

    if ( vehicle.user_id == user_id ) || ( vehicle.owner_id == user_id)
      return vehicle
    else
      if VehicleShare.vehicle_shared_with_user(vehicle.id, user_id).count > 0
        return vehicle
      else
        raise "User have no permission to view vehicle!"
      end
    end
  end

  def device_if_user_can_access_device_with_id (user_id, device_id)
    begin
      device = Device.find_by_imei(device_id)
    rescue ActiveRecord::RecordNotFound
      return nil
    end

    if ( device.user_id == user_id ) || ( device.owner_id == user_id)
      return device
    else
      if VehicleShare.device_shared_with_user(device.imei, user_id).count > 0
        return device
      else
        raise "User have no permission to view device!"
      end
    end
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
