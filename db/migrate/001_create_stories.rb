class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories, :force => true do |t|
      t.column :name, :string
      t.column :link, :string    
    end
  end

  def self.down
    drop_table :stories
  end
end
