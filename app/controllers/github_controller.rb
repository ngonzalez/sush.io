class GithubController < ApplicationController
  def list
    GithubUpdateJob.perform_later name: user_params[:name]
    render json: GithubListJob.perform_now(name: user_params[:name]).to_json, status: 200
  rescue Octokit::NotFound
    render json: { error: t('github.user_not_found') }, status: 200
  rescue Octokit::TooManyRequests
    render json: { error: t('github.too_many_requests') }, status: 200
  end
  private
  def user_params
    params.require(:user).permit(:name)
  end
end