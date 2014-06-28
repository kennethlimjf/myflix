require 'spec_helper'

describe Video do
  
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should belong_to(:category) }

  describe '#search_by_title' do
    before do
      @v1 = Video.create( title: "Amazing Spiderman", description: "This is a description 1." )
      @v2 = Video.create( title: "Amazing Superman", description: "This is a description 2." )
      @v3 = Video.create( title: "Inception", description: "This is a description 3." )
    end

    it 'should return an array of one video for an exact match' do
      results = Video.search_by_title( "Inception" )
      expect(results).to eq([@v3])
    end

    it 'should return array of videos with that contains the search term' do
      results = Video.search_by_title( "man" )
      expect(results).to include( @v1, @v2 )
    end

    it 'should return an empty array if no match with search term' do
      results = Video.search_by_title( "haha" )
      expect(results).to eq([])
    end
  end

end