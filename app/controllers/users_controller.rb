class UsersController < ApplicationController
  def index
    @users = User.includes(:repositories).load
  end
end