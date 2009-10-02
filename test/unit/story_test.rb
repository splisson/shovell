require File.dirname(__FILE__) + '/../test_helper'

class StoryTest < Test::Unit::TestCase
  fixtures :votes, :stories, :users

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
      :link => 'http://www.testsubmission.com/')
    assert s.valid?
  end
  
  def test_votes_association
    assert_equal [ votes(:first), votes(:second) ],
      stories(:first).votes
  end
  
  def test_should_return_highest_vote_id_first
    assert_equal votes(:second), stories(:first).latest_votes.first
  end

  def test_should_return_3_latest_votes
    10.times { stories(:first).votes.create }
    assert_equal 3, stories(:first).latest_votes.size
  end
  
  def test_user_association
    assert_equal users(:patrick), stories(:first).user
  end

  def test_should_increment_votes_counter_cache
    stories(:another).votes.create
    stories(:another).reload
    assert_equal 1, stories(:another).attributes['votes_count']
  end
  
  def test_should_decrement_votes_counter_cache
    stories(:first).votes.first.destroy
    stories(:first).reload
    assert_equal 1, stories(:first).attributes['votes_count']
  end
  
  def test_should_generate_permalink
    s = Story.create(
      :name => 'This#title*is&full/of:special;characters',
      :link => 'http://example.com/'
    )
    assert_equal 'this-title-is-full-of-special-characters', s.permalink
  end
  
  def test_should_act_as_taggable
    stories(:first).tag_with 'book english'
    stories(:first).reload
    assert_equal 2, stories(:first).tags.size
    assert_equal 'book english', stories(:first).tag_list
  end
  
  def test_should_find_tagged_with
    stories(:first).tag_with 'book english'
    assert_equal [ stories(:first) ],
    Story.find_tagged_with('book')
  end
end