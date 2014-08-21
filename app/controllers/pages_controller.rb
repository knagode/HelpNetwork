class PagesController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def show
    @page = Page.find_by slug: params[:slug]
    if !@page
      raise "Error 404 " + params[:slug]
    end

  end
end
