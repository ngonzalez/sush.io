class GithubController < ApplicationController
  before_action :set_page, only: [:list]
  def list
    response = GithubListJob.perform_now name: user_params[:name], page: @page
    GithubUpdateJob.perform_later name: user_params[:name] if @page == 1
    render json: response.to_json, status: 200
  rescue Octokit::NotFound
    render json: { error: t('github.user_not_found') }, status: 200
  rescue Octokit::TooManyRequests
    render json: { error: t('github.too_many_requests') }, status: 200
  rescue Octokit::TooManyLoginAttempts
    render json: { error: t('github.too_many_login_attempts') }, status: 200
  rescue Octokit::Unauthorized
    render json: { error: t('github.unauthorized') }, status: 200
  end
  private
  def user_params
    params.require(:user).permit(:name)
  end
end