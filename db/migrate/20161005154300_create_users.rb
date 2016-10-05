class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :stars
      t.timestamps
    end
    add_index :users, :id
    add_index :users, :name
  end
end