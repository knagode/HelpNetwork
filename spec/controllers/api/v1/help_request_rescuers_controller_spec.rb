require 'spec_helper'

describe Api::V1::HelpRequestRescuersController, :type => :controller do

  describe 'Help Request Rescuer' do

    before(:each) do
      @user = create(:user)
      @user.create_auth_token
      @authentication_token = {:user_id => @user.authentication_tokens.last.user_id, :token => @user.authentication_tokens.last.token}

      @help_request = create(:help_request, user: @user)
      @help_request.find_and_create_nearest_rescuer

      @help_request_rescuer = HelpRequestRescuer.all.first

    end

    it "should update rescuer info" do
      put :update, {id: @help_request_rescuer.id, :authentication_token => @authentication_token, :help_request_rescuer => {state: "confirmed"}, :language => { :locale => "en"}}
      json = JSON.parse(response.body)
      expect(json['success']).to eq true

      @help_request_rescuer.reload
      expect(@help_request_rescuer.state).to eq "confirmed"
    end
  end

end
