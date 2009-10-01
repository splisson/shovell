class AdminController < ApplicationController
  def login 
    if request.post? 
      @current_user  = User.authenticate(params[:name], params[:password]) 
      if @current_user 
        session[:user_id] = @current_user.id
        unless session[:return_to].blank? 
          redirect_to session[:return_to] 
          session[:return_to] = nil 
        else 
          redirect_to :controller => 'stories' 
        end
      else 
        flash.now[:notice] = "Invalid user/password combination" 
      end 
    end 
  end 

  def logout
    session[:user_id] = @current_user = nil
    flash[:notice] = "Logged out" 
    redirect_to(:action => "login") 
  end

  def index
    @total_stories = Story.count 
  end
  
  def show 
    @user = User.find_by_name(params[:id]) 
    @stories_submitted = @user.stories.find(:all, :limit => 6, :order => 'id DESC') 
    @stories_voted_on  = @user.stories_voted_on.find(:all, 
      :limit => 6, :order => 'id DESC')  
  end 

end
