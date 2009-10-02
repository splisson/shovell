class AddStoryCreationDateAndDescription < ActiveRecord::Migration
  
  def self.up
    add_column :stories, :created_at, :datetime
    add_column :stories, :description, :text
  end
  
  def self.down
    remove_column :stories, :created_at
    remove_column :stories, :description
  end
  
end
