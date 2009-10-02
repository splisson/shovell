require File.dirname(__FILE__) + '/../test_helper'
require 'story_controller'

# Re-raise errors caught by the controller.
class StoryController; def rescue_action(e) raise e end; end

class StoryControllerTest < Test::Unit::TestCase
  fixtures :stories, :votes, :users
  
  def setup
    @controller = StoryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_show_index
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:story)
  end
  
  def test_should_show_new
    get_with_user :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:story)
  end
  
  def test_should_show_new_form
    get_with_user :new
    assert_select 'form p', :count => 5
  end
  
  def test_should_add_story
    post_with_user :new, :story => {
      :name => 'test story',
      :link => 'http://www.test.com/'
    }
    assert ! assigns(:story).new_record?
    assert_redirected_to :action => 'index'
    assert_not_nil flash[:notice]
  end
  
  def test_should_reject_missing_story_attribute
    post_with_user :new, :story => { :name => 'story without a link' }
    assert assigns(:story).errors.on(:link)
  end
  
  def test_should_show_story
    get :show, :permalink => 'my-shiny-weblog'
    assert_response :success
    assert_template 'show'
    assert_equal stories(:first), assigns(:story)
  end
  
  def test_should_show_story_vote_elements
    get_with_user :show, :permalink => 'my-shiny-weblog'
    assert_select 'h2 span#vote_score'
    assert_select 'ul#vote_history li', :count => 2
    assert_select 'div#vote_link'
  end
  
  def test_should_accept_vote
    assert stories(:another).votes.empty?
    post_with_user :vote, :id => 2
    assert ! assigns(:story).reload.votes.empty?
  end
  
  def test_should_render_rjs_after_vote_with_ajax
    @request.env['HTTP_ACCEPT'] = 'text/javascript'
    xml_http_request :post_with_user, :vote, :id => 2
    assert_response :success
    assert_template 'vote'
  end
  
  def test_should_redirect_after_vote_with_get
    get_with_user :vote, :id => 2
    assert_redirected_to :action => 'show', :permalink => 'sitepoint-forums'
  end
  
  def test_should_show_story_submitter
    get :show, :permalink => 'my-shiny-weblog'
    assert_select 'p.submitted_by span', 'patrick'
  end
  
  def test_should_indicate_not_logged_in
    get :index
    assert_select 'div#login_logout em', 'Not logged in.'
  end

  def test_should_show_navigation_menu
    get :index
    assert_select 'ul#navigation li', 3
  end
  
  def test_should_indicate_logged_in_user
    get_with_user :index
    assert_equal users(:patrick), assigns(:current_user)
    assert_select 'div#login_logout em a', '(Logout)' 
  end
  
  def test_should_redirect_if_not_logged_in
    get :new
    assert_response :redirect
    assert_redirected_to '/account/login'
  end
  
  def test_should_store_user_with_story
    post_with_user :new, :story => {
      :name => 'story with user',
      :link => 'http://www.story-with-user.com/'
    }
    assert_equal users(:patrick), assigns(:story).user
  end
  
  def test_should_show_index
    get :index
    assert_response :success
    assert_template 'index'
  end
  
  def test_should_show_bin
    get :bin
    assert_response :success
    assert_template 'index'
  end
  
  def test_should_only_list_promoted_on_index
    get :index
    assert_equal [ stories(:promoted) ], assigns(:stories)
  end

  def test_should_only_list_unpromoted_in_bin
    get :bin
    assert_equal [ stories(:another), stories(:first) ],
      assigns(:stories)
  end

  def test_should_use_story_index_as_default
    assert_routing '', :controller => 'story', :action => 'index'
  end
  
  def test_should_show_story_on_index
    get :index
    assert_select 'h2', 'Showing 1 front page story'
    assert_select 'div#content div.story', :count => 1
  end
  
  def test_should_show_stories_in_bin
    get :bin
    assert_select 'h2', 'Showing 2 upcoming stories'
    assert_select 'div#content div.story', :count => 2
  end
  
  def test_should_store_user_with_vote
    post_with_user :vote, :id => 2
    assert_equal users(:patrick), assigns(:story).votes.last.user
  end
  
  def test_should_not_show_vote_button_if_not_logged_in
    get :show, :permalink => 'my-shiny-weblog'
    assert_select 'div#vote_link', false
  end
  
  def test_should_show_story_submitter
    get :show, :permalink => 'my-shiny-weblog'
    assert_select 'p.submitted_by a', 'patrick'
  end

  protected
  
  def get_with_user(action, parameters = nil, session = nil, flash = nil)
    get action, parameters, :user_id => users(:patrick).id
  end
  
  def post_with_user(action, parameters = nil, session = nil, flash = nil)
    post action, parameters, :user_id => users(:patrick).id
  end
  
  def test_should_add_story_with_tags
    post_with_user :new, :tags => 'rails blog', :story => {
        :name => 'story with tags',
        :link => 'http://www.story-with-tags.com/'
    }
    assert_equal 'rails blog', assigns(:story).tag_list
  end
  
  def test_should_show_story_with_tags
    stories(:promoted).tag_with 'apple music'
    get :show, :permalink => 'promoted-story'
    assert_select 'p.tags a', 2
  end
  
  def test_should_find_tagged_stories
    stories(:first).tag_with 'book english'
    get :tag, :id => 'book'
    assert_equal [ stories(:first) ], assigns(:stories)
  end
  
  def test_should_render_tagged_stories
    stories(:first).tag_with 'book english'
    get :tag, :id => 'english'
    assert_response :success
    assert_template 'index'
    assert_select 'div#content div.story', :count => 1
  end

end