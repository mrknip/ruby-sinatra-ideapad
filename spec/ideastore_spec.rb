require_relative 'spec_helper'

describe 'IdeaStore' do
  before (:all) do
    refresh_database
  end

  describe '#create' do
    before do

    end
    it 'adds an idea to the database' do
      target_length = IdeaStore.all.size + 1
      IdeaStore.create('title' => 'test_title', 
                       'description' => 'test_description')
      expect(IdeaStore.all.size).to eq target_length
    end

    it 'cleans the tag data before adding'
  end

  describe '#read' do
    context 'when "all" selected' do
      it 'returns sortable list of ideas' do
        expect(IdeaStore.read(type: :all)).to respond_to :sort
      end
    end

    context 'when ID number given' do
      it 'returns file with that ID number' do
        expect(IdeaStore.read(id: 2).id).to eq 2
      end
    end

    context 'when tag given' do
      it 'returns files with that tag' do
        IdeaStore.read(tag: 'knip').each do |idea|
          expect(idea.tags).to include 'beef'
        end
      end
    end
  end

  describe '#update' do

  end

  describe '#delete' do
  end

  describe '#tagged' do
    before do
      IdeaStore.create({'title' => 'sure', 
                        'description' => 'whatver', 
                        'tags' => 'beef' } )
    end

    it 'returns an array of ideas that have the tag passed to it' do  
      expect(IdeaStore.tagged('beef')).to be_an Array
      sample_idea = IdeaStore.tagged('beef')[0]
      expect(sample_idea.tags).to include('beef')
    end
  end

end