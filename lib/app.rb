ENV['RACK_ENV'] ||= 'development'

require 'ideapad'

class IdeaPadApp < Sinatra::Base
set :method_override, true
set :root, 'lib/app'

  configure :development do
    register Sinatra::Reloader
  end

  # READ
  get '/' do 
    erb :index, locals: { ideas: IdeaStore.all.sort }
  end

  # CREATE
  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  # UPDATE
  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: { idea: idea }
  end

  put '/:id' do |id|
    idea = IdeaStore.find(id.to_i)
    updated_idea = idea.to_h.merge(params[:idea])
    IdeaStore.update(id.to_i, updated_idea)
    redirect '/'
  end

  # DELETE
  delete '/:id' do |id|
    IdeaStore.delete(id)
    redirect '/'
  end

  # RANKING
  post '/:id/like' do |id|
    idea = IdeaStore.find(id)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  not_found do
    erb :error
  end
end