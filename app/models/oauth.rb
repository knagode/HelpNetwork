class Oauth < ActiveRecord::Base
  belongs_to :user

  attr_accessor :access_token
end
