class StoryController < ApplicationController
  before_filter :login_required, :only => [ :new, :vote ]
  
  def index
    fetch_stories 'votes_count >= 5'
  end
  
  def new
    @story = Story.new(params[:story])
    @story.user = @current_user
    if request.post? and @story.save
      @story.tag_with params[:tags] if params[:tags]
      flash[:notice] = 'Story submission succeeded'
      redirect_to :action => 'index'
    end
  end
  
  def show
    @story = Story.find_by_permalink(params[:permalink])
  end
  
  def vote
    @story = Story.find_by_permalink(params[:permalink])
    @story.votes.create(:user => @current_user)

    respond_to do |wants|
      wants.html { redirect_to :action => 'show', 
          :permalink => @story.permalink }
      wants.js   { render }
    end
  end
  
  def bin
    fetch_stories 'votes_count < 5'
    render :action => 'index'
  end
  
  def tag
    @stories = Story.find_tagged_with(params[:id])
    render :action => 'index'
  end

  protected
    def fetch_stories(conditions)
      @stories = Story.find :all,
        :order => 'id DESC',
        :conditions => conditions
    end
end