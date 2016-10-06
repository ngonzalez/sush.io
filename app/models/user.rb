class User < ActiveRecord::Base
  has_many :repositories
  serialize :remote_starred_ids, Array
end