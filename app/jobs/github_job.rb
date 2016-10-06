class GithubJob < ActiveJob::Base
  queue_as :default
  attr_accessor :octokit_user
  def perform args
    raise ArgumentError if !args.has_key? :name
    @octokit_user = Octokit.user args[:name]
  end
end
