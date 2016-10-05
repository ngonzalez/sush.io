class CreateRepositories < ActiveRecord::Migration[5.0]
  def change
    create_table :repositories do |t|
      t.string :name
      t.datetime :date
      t.timestamps
    end
    add_index :repositories, :id
    add_index :repositories, :name
  end
end