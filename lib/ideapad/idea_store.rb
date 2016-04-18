require 'yaml/store'

class IdeaStore
  def self.database
    @database ||= YAML::Store.new 'db/ideapad.yml'
  end

  def self.create(attributes)
    # TODO: clean tag input
    # TODO: use strings throughout
    
    database.transaction do 
      database['ideas'] ||= []
      database['ideas'] << clean!(attributes)
    end
  end

  def self.clean!(attributes)
    unless attributes['tags'].respond_to? :each
      attributes['tags'] = attributes['tags'].split(',').map { |tag| tag.strip }
    end
    attributes
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

  # TODO: sort out case-sensitivity
  def self.tagged(filter)
    all.select { |idea| idea.tags.any? { |tag| tag =~ /#{Regexp.quote(filter)}/i } }
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
      database['ideas'][id] = clean!(data)
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position.to_i)
    end
  end
end