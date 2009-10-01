require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  fixtures :stories, :votes, :users
  def test_should_require_name 
    s = Story.create(:name => nil) 
    assert s.errors.on(:name) 
  end
  def test_should_require_link 
    s = Story.create(:link => nil) 
    assert s.errors.on(:link) 
  end
  def test_should_create_story 
    s = Story.create( 
      :name => 'My test submission', 
      :link => 'http://www.testsubmission.com/',
      :permalink => 'my-test-submission',
      :user_id => 1) 
    assert s.valid? 
  end
  def test_user_association 
    assert_equal users(:patrick), stories(:one).user 
  end 
end
