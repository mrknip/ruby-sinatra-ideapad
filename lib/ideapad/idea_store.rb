require 'yaml/store'

class IdeaStore
  class << self
    def create(attributes)
      # TODO: use strings throughout
      database.transaction do 
        database['ideas'] ||= []
        database['ideas'] << clean!(attributes)
      end
    end

    def read(options = {type: :all})
      if options[:type] == :all
        all
      elsif options[:id]
        find(options[:id])
      elsif options[:tag]
        tagged(options[:tag])
      end  
    end

    def update(id, data)
      database.transaction do
        database['ideas'][id] = clean!(data)
      end
    end

    def delete(position)
      database.transaction do
        database['ideas'].delete_at(position.to_i)
      end
    end

    # HELPER METHODS

    def database
      if ENV['RACK_ENV'] == 'development'
        @database ||= YAML::Store.new 'db/ideapad.yml'
      elsif ENV['RACK_ENV'] == 'test'
        @database ||= YAML::Store.new 'db/teststore.yml'
      end
    end

    def clean!(attributes)
      return attributes unless attributes['tags']
      unless attributes['tags'].respond_to? :each
        attributes['tags'] = attributes['tags'].split(',').map { |tag| tag.strip }
      end
      attributes
    end

    # READ HELPERS
    def all
      ideas = []
      raw_ideas.each_with_index do |data, index|
        ideas << Idea.new(data.merge('id' => index))
      end
      ideas
    end

    def raw_ideas
      database.transaction do |db|
        db['ideas'] || []
      end
    end

    # TODO: sort out case-sensitivity
    def tagged(filter)
      all.select { |idea| idea.tags.any? { |tag| tag =~ /#{Regexp.quote(filter)}/i } }
    end

    def find(id)
      raw_idea = find_raw_idea(id)
      Idea.new(raw_idea.merge('id' => id))
    end

    def find_raw_idea(id)
      database.transaction do 
        database['ideas'].at(id.to_i)
      end
    end

    def size
      size = 0
      database.transaction do
        size = database['ideas'].size
      end
      size
    end

    def delete_all
      (0..size-1).each do |i|
        delete(i)
      end
    end
  end
end