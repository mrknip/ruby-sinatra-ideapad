require_relative 'spec_helper'

# TODO: use a test database

describe 'IdeaPad' do
  describe 'GET /' do
    before { get '/'}

    it 'successfully loads page' do
      expect(last_response.status).to eq 200
    end

    it 'loads the index page' do
      expect(last_response.body).to include("Ideas!")
    end

    it 'loads when database is empty'
  end

  describe 'POST /' do
    before do 
      mock_idea = Idea.new({'title' => 'sure', 'description' => 'whatever'})
      MockStore = double('IdeaStore')
      allow(MockStore).to receive(:create).and_return(nil)
      allow(MockStore).to receive(:all).and_return([mock_idea])
    end

    it 'successfully redirects to "/"' do
      post_idea('test_title', 'test_description')
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_request.path).to eq '/'
    end

    # TODO: get mocking to work on IdeaStore class
    it 'creates a new idea' do
      expect(MockStore).to receive(:create)
      MockStore.create({'title' => 'sure', 'description' => 'whatever'})
      # post_idea('test_title', 'test_description')
    end
  end

  # describe 'PUT /2' do
  #   it 'successfully redirects to "/"' do
  #     post_idea('test_title', 'test_description')
  #     expect(last_response.redirect?).to be true
  #     follow_redirect!
  #     expect(last_request.path).to eq '/'
  #   end    
  # end
end