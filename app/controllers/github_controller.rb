class GithubController < ApplicationController
  before_action :set_page, only: [:index, :list]
  before_action :set_user, only: [:index, :list]
  def index ; end
  def list
    GithubUpdateJob.perform_now user: @user if !@user.last_updated_at || (Time.now - @user.last_updated_at > 1.hour)
    @repositories = @user.repositories.order("remote_created_at::timestamp DESC").paginate page: @page, per_page: ITEMS_PER_PAGE
    render "github/list", layout: false
  rescue Octokit::NotFound
    render text: t('github.user_not_found'), status: 200
  rescue Octokit::TooManyRequests
    render text: t('github.too_many_requests'), status: 200
  rescue Octokit::TooManyLoginAttempts
    render text: t('github.too_many_login_attempts'), status: 200
  rescue Octokit::Unauthorized
    render text: t('github.unauthorized'), status: 200
  end
  private
  def set_user
    if params[:user]
      @user = User.find_by name: user_params[:name]
      @user = User.create! name: user_params[:name] if !@user
    else
      @user = User.new
    end
  end
  def user_params
    params.require(:user).permit(:name)
  end
  def set_page
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
  end
end