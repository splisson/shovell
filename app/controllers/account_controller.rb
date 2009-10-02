class AccountController < ApplicationController

  def login
    if request.post?
      @current_user = User.find_by_login_and_password(
        params[:login], params[:password])
      unless @current_user.nil?
        session[:user_id] = @current_user.id
        unless session[:return_to].blank?
          redirect_to session[:return_to]
          session[:return_to] = nil
        else
          redirect_to :controller => 'story'
        end
      end
    end
  end

  def logout
    session[:user_id] = @current_user = nil
  end

  def show
    @user = User.find_by_login(params[:id])
    @stories_submitted = @user.stories.find(:all, 
        :limit => 6, :order => 'id DESC')
    @stories_voted_on  = @user.stories_voted_on.find(:all, 
        :limit => 6, :order => 'id DESC')
  end
end