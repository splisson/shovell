module StoryHelper
  def story_list_heading
    story_type = case controller.action_name
        when 'index': 'front page story'
        when 'bin': 'upcoming story'
        when 'tag': 'tagged story'
      end
    "Showing #{ pluralize(@stories.size, story_type) }"    
  end
end