class HomeController < ApplicationController
  before_action :set_page, only: [:index]
  before_action :set_user, only: [:index]
  def index ; end
end