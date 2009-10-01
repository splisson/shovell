class Story < ActiveRecord::Base
  before_create :generate_permalink
  
  belongs_to :user 
  validates_presence_of :name, :link
  has_many :votes 
  def latest_votes 
    votes.find(:all, :order => 'id DESC', :limit => 3) 
  end
  
  protected 
    def generate_permalink 
      self.permalink = name.downcase.gsub(/\W/, '-') 
    end 
end
