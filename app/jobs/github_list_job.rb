class GithubListJob < GithubJob
  def perform args
    super args
    octokit_user.rels[:repos].get.data.map do |item|
      item.to_hash.slice :description, :html_url, :name, :created_at
    end
  end
end