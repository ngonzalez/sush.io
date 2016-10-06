class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.text :remote_starred_ids
      t.timestamps
    end
    add_index :users, :id
    add_index :users, :name
  end
end