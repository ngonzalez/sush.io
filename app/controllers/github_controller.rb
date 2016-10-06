class GithubController < ApplicationController
  def index
    user = Octokit.user params[:user]
    data = user.rels[:repos].get.data
    render json: data.map{|item| item.to_hash.slice(:description, :html_url, :name, :created_at) }.to_json, status: 200
  rescue
    render json: { error: t('github.error') }, status: 200
  end
end