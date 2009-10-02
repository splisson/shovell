class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.column :story_id, :integer
      t.column :created_at, :datetime
    end
  end
  
  def self.down
    drop_table :votes
  end
end
