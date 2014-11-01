require 'spec_helper'

describe Api::V1::HelpRequestsController, :type => :controller do

  describe 'help request creation' do

    before(:each) do
      @user = create(:user)
      @user.create_auth_token
      @authentication_token = {:user_id => @user.authentication_tokens.last.user_id, :token => @user.authentication_tokens.last.token}
    end

    it "Should generate entity" do
      count_requests = HelpRequest.all.count
      count_request_rescuesrs = HelpRequestRescuer.all.count
      post :create, {:authentication_token => @authentication_token, :help_request => {:latitude => 14.111, :longitude => 6.22121, :description => "I need help here!"}, :language => { :locale => "en"}}
      json = JSON.parse(response.body)
      expect(json['success']).to eq true
      expect(HelpRequest.all.count).to eq count_requests + 1
      expect(HelpRequestRescuer.all.count).to eq count_requests + 1
    end

  end

end
