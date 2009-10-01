require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users, :stories, :votes 
  def test_stories_association 
    assert_equal 2, users(:patrick).stories.size 
    assert_equal stories(:one), users(:patrick).stories.first 
  end
end
