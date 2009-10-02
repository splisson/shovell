class Story < ActiveRecord::Base
  acts_as_taggable
  before_create :generate_permalink

  validates_presence_of :name, :link
  belongs_to :user
  has_many :votes

  def latest_votes
    votes.find(:all, :order => 'id DESC', :limit => 3)
  end

  protected
    def generate_permalink
      self.permalink = name.downcase.gsub(/\W/, '-')
    end
end