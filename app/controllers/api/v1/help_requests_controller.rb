class Api::V1::HelpRequestsController < Api::V1::ApiController
  before_filter :restrict_access

  def create
    help_request = HelpRequest.new(help_request_params)
    help_request.user = @user
    help_request.save!

    help_request.find_and_create_nearest_rescuer

    render :json => {:success => true, :errors => [], :message => "We notified someone that you need help. You will be notified when he confirms that he can help you!"}
  end

  def confirm
    render :json => {:success => true, :errors => [], :message => "User was notified that you are comming. Thanks!"}
  end

  def cancel
    render :json => {:success => true, :errors => [], :message => "We should search for next nearest user"}
  end

  def show
    render :json => {:success => true, :help_request => @help_request}
  end


private
  def help_request_params
    params.require(:help_request).permit(
      :latitude, :longitude, :description
    )
  end

end
