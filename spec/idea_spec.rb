describe 'Idea' do
  before do
    @idea = Idea.new({'title' => 'TEST', 'description' => 'TESTDEE'})
  end

  it 'has a title' do
    expect(@idea.title).to eq "TEST"
  end

  it 'has a description' do
    expect(@idea.description).to eq "TESTDEE"
  end

  it 'has a rank' do
    expect(@idea.rank).to eq 0
  end

  describe '#to_h' do
    it 'returns a hash' do
      expect(@idea.to_h).to be_a Hash
    end
  end

  
  
end