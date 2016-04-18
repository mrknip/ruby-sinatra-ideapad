require 'yaml/store'

class IdeaStore
  def self.database
    @database ||= YAML::Store.new 'db/ideapad.yml'
  end

  def self.create(attributes)
    database.transaction do 
      database['ideas'] ||= []
      database['ideas'] << attributes
    end
  end

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, index|
      ideas << Idea.new(data.merge('id' => index))
    end
    ideas
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge('id' => id))
  end

  def self.find_raw_idea(id)
    database.transaction do 
      database['ideas'].at(id.to_i)
    end
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position.to_i)
    end
  end
end