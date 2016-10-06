class UpdateUsersAddLastUpdated < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_updated_at, :datetime
  end
end