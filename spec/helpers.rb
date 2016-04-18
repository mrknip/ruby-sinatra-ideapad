module Helpers
  def post_idea(title, description)
    post '/', idea: {'title' => title,
                     'description' => description}
  end
end