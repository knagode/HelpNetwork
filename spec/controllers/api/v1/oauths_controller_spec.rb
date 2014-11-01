# require 'spec_helper'

# describe Api::V1::OauthsController, :type => :controller do

#   describe "User registration with facebook or google provider" do
#     it "should create a new user, then the user should login, without creating a new one - facebook" do
#       post :create, {:oauth => {:provider => 'facebook', :token => 'banana'}, :mobile_device => {:model => 'iOS'}, :language => { :locale => "en"}}

#       json = JSON.parse(response.body)
#       expect(json['success']).to eq true
#       expect(json['user']['email']).to eq "test@test.com"
#       expect(json['authentication_token']['user_id']).to eq User.last.id

#       last_user = User.last
#       user_count_before = User.count
#       post :create, {:oauth => {:provider => 'facebook', :token => 'banana'}, :mobile_device => {:model => 'iOS'}, :language => { :locale => "en"}}
#       json = JSON.parse(response.body)
#       expect(json['success']).to eq true
#       expect(user_count_before).to eq User.count
#       expect(last_user).to eq User.last
#       expect(Oauth.count).to eq 1
#       expect(last_user.strategy? "facebook").to eq true
#     end

#     it "should create a new user, then the user should login, without creating a new one - google" do
#       post :create, {:oauth => {:provider => 'google', :token => 'banana'}, :mobile_device => {:model => 'iOS'}, :language => { :locale => "en"}}

#       json = JSON.parse(response.body)

#       expect(json['success']).to eq true
#       expect(json['user']['email']).to eq "test@test.com"
#       expect(json['authentication_token']['user_id']).to eq User.last.id

#       last_user = User.last
#       user_count_before = User.count
#       post :create, {:oauth => {:provider => 'facebook', :token => 'banana'}, :mobile_device => {:model => 'iOS'}, :language => { :locale => "en"}}
#       json = JSON.parse(response.body)
#       expect(json['success']).to eq true
#       expect(user_count_before).to eq User.count
#       expect(last_user).to eq User.last
#       expect(Oauth.count).to eq 2
#       expect(last_user.strategy? "google").to eq true
#     end

#     it "Should create a new oauth for a user that already exists" do
#       user = create(:user, :email => "test@test.com")
#       user.create_auth_token

#       users_count = User.count
#       oauths_count = Oauth.count
#       post :create, {:oauth => {:provider => 'facebook', :token => 'banana'}, :mobile_device => {:model => 'iOS'}, :language => { :locale => "en"}}
#       json = JSON.parse(response.body)
#       expect(json['success']).to eq true
#       expect(users_count).to eq User.count
#       expect(oauths_count).to eq 0
#       expect(Oauth.count).to eq 1
#     end

#     it "Should not create a user because provider wrong" do
#       post :create, {:oauth => {:provider => 'twitter', :token => 'banana'}, :mobile_device => {:model => 'iOS'}, :language => { :locale => "en"}}
#       json = JSON.parse(response.body)
#       expect(json['success']).to eq false
#       expect(json).to have_key('errors')
#       expect(json["errors"]).to have_key('provider')
#       expect(User.count).to eq 0
#       expect(Oauth.count).to eq 0
#     end

#   end

# end
