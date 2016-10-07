class User < ActiveRecord::Base
  has_many :repositories
  serialize :remote_starred_ids, Array
  def starred_repositories
    repositories.select do |item|
      remote_starred_ids.include? item.remote_id
    end
  end
end