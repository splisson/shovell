class ApplicationController < ActionController::Base
  before_filter :fetch_logged_in_user
  
  protected
  def fetch_logged_in_user
    return if session[:user_id].blank?
    @current_user = User.find_by_id(session[:user_id])
  end
  
  def logged_in?
    ! @current_user.blank?
  end
  helper_method :logged_in?
  
  def login_required
    return true if logged_in?
    session[:return_to] = request.request_uri
    redirect_to :controller => "/account", :action => "login" and return false
  end

end