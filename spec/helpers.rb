module Helpers
  def post_idea(title, description)
    post '/', idea: {'title' => title,
                     'description' => description}
  end

  def create_idea
    IdeaStore.create('title' => 'test_title', 
                       'description' => 'test_description')
  end

  def refresh_database
    IdeaStore.delete_all
    3.times { create_idea }
    2.times { IdeaStore.create({'title' => 'sure', 
                          'description' => 'whatver', 
                          'tags' => 'beef' }) }
  end
end