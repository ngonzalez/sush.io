class GithubController < ApplicationController
  before_action :set_page, only: [:list]
  before_action :set_user, only: [:list]
  def list
    GithubUpdateJob.perform_now user: @user if !@user.last_updated_at || (Time.now - @user.last_updated_at > 1.hour)
    @repositories = @user.repositories.paginate page: @page, per_page: 5
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
    @user = User.find_by name: user_params[:name]
    @user = User.create! name: user_params[:name] if !@user
  end
  def user_params
    params.require(:user).permit(:name)
  end
end