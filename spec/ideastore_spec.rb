describe 'IdeaStore' do
  
  describe '#tagged' do
    before do
      IdeaStore.create({'title' => 'sure', 
                        'description' => 'whatver', 
                        'tags' => ['beef'] } )
    end

    it 'returns an array of ideas that have the tag passed to it' do  
      expect(IdeaStore.tagged('beef')).to be_an Array
      sample_idea = IdeaStore.tagged('beef')[0]
      expect(sample_idea.tags).to include('beef')
    end
  end

end