class Api::V1::UsersController < Api::V1::ApiController
  before_filter :restrict_access, :only => [:update, :show, :relationships]

  def create
    user = User.create(user_params)

    if user.valid?
      user.send_email_verification "en"
      create_mobile_device user
      render :json => {:success => true, :errors => user.errors.messages, user: user_mapped_values(user)}.to_json
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

  def send_push
    @user.send_push
  end

  def show
    vehicle_ids = VehicleShare.vehicle_id_for_user(@user.id)
    # vehicles = Vehicle.for_user_or_shared(@user.id, vehicle_ids)
    vehicles_user = Vehicle.for_user(@user.id)
    vehicles_shared = Vehicle.shared(vehicle_ids)
    user_vehicles_id_array = Array.new
    vehicles_user.each do |vehicle_user|
      user_vehicles_id_array << vehicle_user.id
    end

    users_share_to_ids = VehicleShare.users_following_vehicles(vehicles_user.map(&:id))
    users_share_to = User.find_in_ids(users_share_to_ids)
    users_share_to = users_share_to.uniq

    scores = ["breaking" => 5,"speeding" => 10]
    render :json => {:success => true, :user => @user, :vehicles_user_count => vehicles_user.count, :vehicles_shared_count => vehicles_shared.count, :users_share_to_count => users_share_to.count, :scores => scores}.to_json
  end

private
  def user_params
    params.require(:user).permit(
      :email, :password, :name, :birthday, :sex
    )
  end

end
