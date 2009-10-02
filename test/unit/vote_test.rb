require File.dirname(__FILE__) + '/../test_helper'

class VoteTest < Test::Unit::TestCase
  fixtures :votes, :stories, :users
  
  def test_story_association
    assert_equal stories(:first), votes(:first).story
  end
  
  def test_user_association
    assert_equal users(:john), votes(:second).user
  end
end