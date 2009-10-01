require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  fixtures :users
  def test_should_show_login_form
    get :login
    assert_response :success
    assert_template 'login'
    assert_select 'form input', 3
  end
  def test_should_perform_user_login 
    post :login, :name => 'patrick', :password => 'veodia' 
    assert_redirected_to :controller => 'stories' 
    assert_equal users(:patrick).id, session[:user_id] 
    assert_equal users(:patrick), assigns(:current_user) 
  end
  def test_should_fail_user_login 
    post :login, :name => 'no such', :password => 'user' 
    assert_response :success 
    assert_template 'login' 
    assert_nil session[:user_id] 
  end
  def test_should_redirect_after_login_with_return_url 
    post :login, { :name => 'patrick', :password => 'veodia' }, 
        :return_to => '/stories/new' 
    assert_redirected_to '/stories/new' 
  end
  def test_should_logout_and_clear_session 
    post :login, :name => 'patrick', :password => 'veodia' 
    assert_not_nil assigns(:current_user) 
    assert_not_nil session[:user_id] 
    get :logout 
    assert_redirected_to :controller => 'admin', :action => 'login' 
    assert_nil assigns(:current_user) 
    assert_nil session[:user_id] 
  end
end
