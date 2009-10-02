class CreateUsers < ActiveRecord::Migration
  
  def self.up
    create_table :users do |t|
      t.column :login, :string
      t.column :password, :string
      t.column :name, :string
      t.column :email, :string
    end
    add_column :stories, :user_id, :integer
    add_column :votes, :user_id, :integer
  end
  
  def self.down
    drop_table :users
    remove_column :stories, :user_id
    remove_column :votes, :user_id
  end
  
end
