#####################
# User Authentication
#####################
#
# Include this module inside ApplicationController to enable controller
# authentication logic. You can then limit the access for a controller
# action to only logged in users.
#
# Example:
# => class OffersController < ApplicationController
# =>   require_authentication only: [:new, :create]
# => ...
module SessionsControllerConcern
  extend ActiveSupport::Concern

  included do
    before_filter :authenticate_from_cookie
    helper_method :logged_in?, :current_user
  end

  # Tries to authenticate a user (ensure a user is authenticatable
  # before trying to authenticate).
  def authenticate_user(user, remember=true)
    if user && user.authenticatable?
      session[:user_id] = user.id
      remember ? remember_authentication! : forget_authentication!
    end
  end

  # Tries to authenticate a user from a stored cookie data. Unlike
  # authenticate_user method it returns boolean value to minimize
  # database calls.
  def authenticate_from_cookie
    return true if logged_in?
    return false unless cookies.signed[:remember_authentication_token]
    user = authenticate_user(
      User.authenticatable.find_by_id_and_password_digest(*cookies.signed[:remember_authentication_token]),
      true
    ).present?
    cookies.signed[:remember_authentication_token] = nil unless user
    user
  end

  # Destroys active user session and logs out a user.
  def unauthenticate
    session[:user_id] = nil
    forget_authentication!
  end

  # Checks if a user is authenticated.
  def logged_in?
    session[:user_id].present?
  end

  # Sets authentication cookei thus the next time a user is
  # logged in automatically.
  def remember_authentication!
    if params && params.has_key?(:user) && params[:user].has_key?(:remember) && params[:user][:remember] == "1"
      if Rails.env.production?
        cookies.permanent.signed[:remember_authentication_token] = { :value => [current_user.id, current_user.password_digest], :domain => ".#{request.domain}" } if logged_in?
      else
        cookies.permanent.signed[:remember_authentication_token] = { :value => [current_user.id, current_user.password_digest] } if logged_in?
      end
    else
      if Rails.env.production?
        cookies.signed[:remember_authentication_token] = { :value => [current_user.id, current_user.password_digest], :expires => 1.year.from_now.utc, :domain => ".#{request.domain}" } if logged_in?
      else
        cookies.signed[:remember_authentication_token] = { :value => [current_user.id, current_user.password_digest], :expires => 1.year.from_now.utc } if logged_in?
      end
    end
  end

  # Returns currently authenticated user.
  def current_user
    @current_user ||= User.authenticatable.find_by_id(session[:user_id]) if session[:user_id]
    #unauthenticate unless @current_user
    @current_user

  end

  # Removes authentication cookei.
  def forget_authentication!
    if Rails.env.production?
      cookies.delete :remember_authentication_token, :domain => ".#{request.domain}"
    else
      cookies.delete(:remember_authentication_token)
    end

  end

end
