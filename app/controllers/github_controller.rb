class GithubController < ApplicationController
  before_action :set_github_service
  def list
    if @service
      render json: @service.list_repositories.to_json, status: 200
    else
      render json: { error: t('github.user_not_found') }, status: 200
    end
  end
  def update
    if @service
      @service.update_user
      head :ok
    else
      head :unprocessable_entity
    end
  end
  private
  def user_params
    params.require(:user).permit(:name)
  end
  def set_github_service
    @service = GithubService.new user_params
  rescue Octokit::NotFound
    # 
  end
end