class GithubJob < ActiveJob::Base
  queue_as :default
  attr_accessor :octokit_user
  def perform args
    raise ArgumentError if !args.has_key? :name
    client = Octokit::Client.new access_token: GITHUB_TOKEN
    @octokit_user = client.user args[:name]
  end
end