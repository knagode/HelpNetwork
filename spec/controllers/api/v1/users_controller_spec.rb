require 'spec_helper'

describe Api::V1::UsersController, :type => :controller do

  describe 'User registration' do
    it "Should return false if data not correct" do
      post :create, {:user => {:email => 'asd', :password => 'asd'}, :language => { :locale => "en"}}
      json = JSON.parse(response.body)
      expect(json['success']).to eq false
    end

    it "Should return true, register a new user and create a user device and authentication token" do
      post :create, {:user => {:email => 'user@example.com', :password => 'foobar', :sex => 1, :name => "Dzoko", :birthday => "3-7-2011"}, :mobile_device => {:model => 'iOS'}, :language => { :locale => "en"}}
      json = JSON.parse(response.body)
      mobile_device = MobileDevice.last
      expect(json['success']).to eq true
      expect(json).to have_key('authentication_token')
      expect(json).to have_key('user')
      expect(mobile_device).not_to eq nil
    end

  end

  describe 'User update' do

    before(:each) do
      @user = create(:user)
      @user.create_auth_token
      @authentication_token = {:user_id => @user.authentication_tokens.last.user_id, :token => @user.authentication_tokens.last.token}

    end

    it "It should update the user data" do

      post :update, {:authentication_token => @authentication_token, :language => { :locale => "en"}, :user => { :email => "asd@asd.com" }}
      json = JSON.parse(response.body)

      expect(json['success']).to eq true
      expect(json).to have_key('user')
      expect(json["user"]["email"]).not_to eq @user.email
    end

    it "It should not update the user data if email is invalid" do
      post :update, {:authentication_token => @authentication_token, :language => { :locale => "en"}, :user => { :email => "asd" }}
      json = JSON.parse(response.body)

      expect(json['success']).to eq false
      expect(json).to have_key('errors')
      expect(json["errors"]).to have_key('email')
    end

    it "should return the user data" do
      post :show, {:authentication_token => @authentication_token, :language => { :locale => "en"}}

      json = JSON.parse(response.body)

      expect(json['success']).to eq true
      expect(json).to have_key('user')
    end



  end




end
