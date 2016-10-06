class CreateRepositories < ActiveRecord::Migration[5.0]
  def change
    create_table :repositories do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.integer :remote_id, null: false
      t.datetime :remote_created_at, null: false
      t.timestamps
    end
    add_index :repositories, :id
    add_index :repositories, :name
  end
end