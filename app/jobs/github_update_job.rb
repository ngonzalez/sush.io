class GithubUpdateJob < ActiveJob::Base
  queue_as :default
  attr_accessor :client, :user
  def perform args
    ActiveRecord::Base.transaction do
      begin
        raise ArgumentError if !args.has_key?(:user) || !args[:user].is_a?(User)
        @user = args[:user]
        @client = Octokit::Client.new access_token: GITHUB_TOKEN
        update_repositories
        update_starred_ids
        user.update! last_updated_at: Time.now
      rescue Exception => e
        raise ActiveRecord::Rollback
      end
    end
  end
  private
  def get_resource name
    page = 1
    response = client.send name, user.name, per_page: 100, page: page
    last_response = client.last_response
    while page < total_pages
      page += 1
      response += client.send name, user.name, per_page: 100, page: page
    end
    return response
  end
  def total_pages
    client.last_response.rels[:last] ? client.last_response.rels[:last].href.match(/page=(\d+).*$/)[1].to_i : 1
  end
  def update_repositories
    results = get_resource :repos
    user.repositories.select{|repository| results.map(&:name).exclude?(repository.name) }.each &:destroy
    results.each do |item|
      next if user.repositories.detect{|repository| repository.name == item[:name] }
      user.repositories.create! name: item[:name], remote_id: item[:id], remote_created_at: item[:created_at]
    end
  end
  def update_starred_ids
    remote_starred_ids = get_resource(:starred).map(&:id)
    user.update! remote_starred_ids: remote_starred_ids if @user.remote_starred_ids != remote_starred_ids
  end
end