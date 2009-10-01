require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  fixtures :votes, :stories 
  def test_story_association 
    assert_equal stories(:one), votes(:one).story 
  end
  def test_votes_association 
    assert_equal [ votes(:one), votes(:two) ], 
        stories(:one).votes 
  end
  def test_should_return_highest_vote_id_first 
    assert_equal votes(:two), stories(:one).latest_votes.first 
  end 
  def test_should_return_3_latest_votes 
    10.times { stories(:one).votes.create } 
    assert_equal 3, stories(:one).latest_votes.size 
  end
  def test_votes_association 
    assert_equal 1, users(:patrick).votes.size 
    assert_equal votes(:two), users(:john).votes.first 
  end
  def test_user_association 
    assert_equal users(:john), votes(:two).user 
  end
end
