class GithubUpdateJob < GithubJob
  attr_accessor :user
  def perform args
    ActiveRecord::Base.transaction do
      begin
        super args
        set_user
        update_repositories
        update_starred_ids
      rescue Exception => e
        raise ActiveRecord::Rollback
      end
    end
  end
  private
  def set_user
    @user = User.find_by name: client.login
    @user = User.create! name: client.login if !@user
  end
  def get_resource name
    page = 1
    response = client.send name, github_username, per_page: 10, page: page
    last_response = client.last_response
    while page < total_pages
      page += 1
      response += client.send name, github_username, per_page: 10, page: page
    end
    return response
  end
  def update_repositories
    get_resource(:repos).each do |item|
      next if user.repositories.detect{|repository| repository.name == item[:name] }
      user.repositories.create! name: item[:name], remote_id: item[:id], remote_created_at: item[:created_at]
    end
  end
  def update_starred_ids
    remote_starred_ids = get_resource(:starred).map(&:id)
    user.update! remote_starred_ids: remote_starred_ids if @user.remote_starred_ids != remote_starred_ids
  end
end