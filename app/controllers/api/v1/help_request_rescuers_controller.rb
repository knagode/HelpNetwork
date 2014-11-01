class Api::V1::HelpRequestRescuersController < Api::V1::ApiController
  before_filter :restrict_access
  before_filter :load, only: [:show, :update]

  def load
    @help_request_rescuer = HelpRequestRescuer.find(params[:id])
    if @help_request_rescuer.user != @user
      raise "You should not see this";
    end
  end

  def show
    render :json => {:success => true, :help_request_rescuer => {state: @help_request_rescuer.state}, help_request: help_request}.to_json
  end

  def update
    @help_request_rescuer.update_attributes(help_request_rescuer_params)
    if @help_request_rescuer.valid?
      render :json => {:success => true, :errors => [], :message => "Updated successfully"}
    else
      render :json => {:success => false, :errors => @help_request_rescuer.errors.messages}.to_json
    end
  end


private
  def help_request_rescuer_params
    params.require(:help_request_rescuer).permit(
      :latitude, :longitude, :description, :state
    )
  end

end
