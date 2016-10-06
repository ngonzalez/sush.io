class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def set_page
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
  end
end