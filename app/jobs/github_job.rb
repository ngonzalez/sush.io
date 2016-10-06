class GithubJob < ActiveJob::Base
  queue_as :default
  attr_accessor :client, :github_username
  def perform args
    raise ArgumentError if !args.has_key?(:name) || args[:name].blank?
    @github_username = args[:name]
    @client = Octokit::Client.new access_token: GITHUB_TOKEN
  end
  def total_pages
    client.last_response.rels[:last] ? client.last_response.rels[:last].href.match(/page=(\d+).*$/)[1].to_i : 1
  end
end