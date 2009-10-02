require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :stories, :votes
  
  def test_stories_association
    assert_equal 2, users(:patrick).stories.size
    assert_equal stories(:first), users(:patrick).stories.first
  end
  
  def test_votes_association
    assert_equal 1, users(:patrick).votes.size
    assert_equal votes(:second), users(:john).votes.first
  end
  
  def test_stories_voted_on_association
    assert_equal [ stories(:first) ],
        users(:patrick).stories_voted_on
  end
end
