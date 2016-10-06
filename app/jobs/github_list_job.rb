class GithubListJob < GithubJob
  def perform args
    super args
    response = client.repos github_username, per_page: 5, page: args[:page]
    results = response.map{ |item| item.to_hash.slice(:description, :html_url, :name, :created_at) }
    return { results: results, page: args[:page], total_pages: total_pages }
  end
end