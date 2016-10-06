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
    @user = User.find_by name: octokit_user.login
    @user = User.create! name: octokit_user.login if !@user
  end
  def update_repositories
    octokit_user.rels[:repos].get.data.each do |item|
      next if user.repositories.detect{|repository| repository.name == item[:name] }
      user.repositories.create! name: item[:name], remote_id: item[:id], remote_created_at: item[:created_at]
    end
  end
  def update_starred_ids
    remote_starred_ids = octokit_user.rels[:starred].get.data.map(&:id)
    user.update! remote_starred_ids: remote_starred_ids if @user.remote_starred_ids != remote_starred_ids
  end
end