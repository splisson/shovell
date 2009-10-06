require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

# Re-raise errors caught by the controller.
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase
  fixtures :users, :stories, :votes
  def setup
    @controller = AccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

def test_should_show_login_form
    get :login
    assert_response :success
    assert_template 'login'    
    assert_select 'form p', 4
  end
  
  def test_should_perform_user_login
    post :login, :login => 'patrick', :password => 'sekrit'
    assert_redirected_to :controller => 'story'
    assert_equal users(:patrick).id, session[:user_id]
    assert_equal users(:patrick), assigns(:current_user)
  end
  
  def test_should_fail_user_login
    post :login, :login => 'no such', :password => 'user'
    assert_response :success
    assert_template 'login'
    assert_nil session[:user_id]
  end
  
  # def test_should_redirect_after_login_with_return_url
#     post :login, { :login => 'patrick', :password => 'sekrit' },
#         :return_to => '/story/new'
#     assert_redirected_to '/story/new'
#   end

  def test_should_logout_and_clear_session
    post :login, :login => 'patrick', :password => 'sekrit'
    assert_not_nil assigns(:current_user)
    assert_not_nil session[:user_id]

    get :logout
    assert_response :success
    assert_template 'logout'
    assert_select 'h2', 'Logout successful'

    assert_nil assigns(:current_user)
    assert_nil session[:user_id]
  end
  
  def test_should_show_user
    get :show, :id => 'patrick'
    assert_response :success
    assert_template 'show'
    assert_equal users(:patrick), assigns(:user)
  end
  
  def test_should_show_user
    get :show, :id => 'patrick'
    assert_response :success
    assert_template 'show'
    assert_equal users(:patrick), assigns(:user)
  end
  
  def test_should_show_submitted_stories
    get :show, :id => 'patrick'
    assert_select 'div#stories_submitted div.story', :count => 2
  end

  def test_should_show_stories_voted_on
    get :show, :id => 'patrick'
    assert_select 'div#stories_voted_on div.story', :count => 1
  end
end
