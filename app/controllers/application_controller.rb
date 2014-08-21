class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  respond_to :html

  include SessionsControllerConcern

  # Returns currently authenticated user.
  def current_user
    @current_user ||= User.authenticatable.find_by_id(session[:user_id]) if session[:user_id]
    #unauthenticate unless @current_user
    @current_user
  end
end
