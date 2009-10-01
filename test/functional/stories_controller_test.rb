require 'test_helper'


class StoriesControllerTest < ActionController::TestCase
  fixtures :stories, :votes, :users
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stories)
  end

  test "should get new" do
    get_with_user :new
    assert_response :success
    assert_template 'new' 
    assert_not_nil assigns(:story)
  end
  
  def test_should_show_new_form 
    get_with_user :new 
    assert_select 'form p', :count => 4 
  end
  
  def test_should_create_story 
    assert_difference('Story.count') do
      post_with_user :create, :story => { 
              :name => 'test story',
              :link => 'http://www.test.com/',
              :permalink => 'test-story'
      }
    end
    assert ! assigns(:story).new_record? 
    assert_redirected_to story_path(assigns(:story))
    assert_not_nil flash[:notice] 
  end
  
  def test_should_reject_missing_story_attribute 
    post_with_user :create, :story => { :name => 'story without a link' } 
    assert assigns(:story).errors.on(:link) 
  end

  test "should show story" do
    get_with_user :show, :permalink => stories(:one).permalink
    assert_response :success
  end

  test "should get edit" do
    get_with_user :edit, :id => stories(:one).to_param
    assert_response :success
  end

  test "should update story" do
    put_with_user :update, :id => stories(:one).to_param, :story => { :name => 'updated name' }
    assert_not_nil assigns(:story)
    assert_redirected_to story_path(assigns(:story))
  end

  test "should destroy story" do
    assert_difference('Story.count', -1) do
      delete :destroy, :id => stories(:one).to_param
    end

    assert_redirected_to stories_path
  end
  
  def test_should_show_story_submitter
    get_with_user :show, :permalink => 'my-shiny-weblog' 
    assert_select 'p.submitted_by span', 'patrick' 
  end
  
  def test_should_indicate_not_logged_in 
    get :index 
    assert_select 'div#login_logout em', 'Not logged in.' 
  end
  def test_should_indicate_logged_in_user 
    get_with_user :index 
    assert_equal users(:patrick), assigns(:current_user) 
    assert_select 'div#login_logout em a', '(Logout)' 
  end
  def test_should_redirect_if_not_logged_in 
    get :new 
    assert_response :redirect 
    assert_redirected_to '/admin/login' 
  end
  
  def test_should_show_story_vote_elements 
    get_with_user :show, :permalink => stories(:one).permalink
    assert_equal 2, assigns(:story).votes.size 
    puts "\nstory.id=#{assigns(:story).id}"
    RAILS_DEFAULT_LOGGER.info("\n story.id=#{assigns(:story).id} \n")
    assert_select 'span#vote_score' 
    assert_select 'ul#vote_history li', :count => 2 
    assert_select 'div#vote_link' 
  end
  
  def test_should_accept_vote 
    assert stories(:two).votes.empty? 
    post_with_user :vote, :id => 2 
    assert ! assigns(:story).reload.votes.empty? 
  end
  
  def test_should_render_rjs_after_vote_with_ajax 
    xml_http_request :post, :vote, :id => 2, :user_id => users(:patrick).id 
    assert_response :success 
    assert_template 'vote' 
  end
  
  def test_should_redirect_after_vote_with_get 
    get_with_user :vote, :id => 2 
    assert_redirected_to :action => 'show', 
        :permalink => 'sitepoint-forums' 
  end
  def test_should_store_user_with_story 
    post_with_user :create, :story => { 
      :name => 'story with user', 
      :link => 'http://www.story-with-user.com/',
      :permalink => 'test-story' 
    }
    assert_equal users(:patrick), assigns(:story).user 
  end
  
  protected 
  def get_with_user(action, parameters = nil, session = nil, 
                    flash = nil) 
    get action, parameters, :user_id => users(:patrick).id 
  end 
  def post_with_user(action, parameters = nil, session = nil, 
                     flash = nil) 
    post action, parameters, :user_id => users(:patrick).id 
  end
  def put_with_user(action, parameters = nil, session = nil, 
                     flash = nil) 
    put action, parameters, :user_id => users(:patrick).id 
  end
end
