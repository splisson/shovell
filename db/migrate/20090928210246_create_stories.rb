class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.column :name, :string 
      t.column :link, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end
