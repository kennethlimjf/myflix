require 'spec_helper'

describe Video do
  
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should belong_to(:category) }
  it { should have_many(:reviews).order("created_at DESC") }

  describe 'search_by_title' do
    let(:v1) { Video.create( title: "Amazing Spiderman", description: "This is a description 1.", created_at: Time.now - 1 ) }
    let(:v2) { Video.create( title: "Amazing Superman", description: "This is a description 2.", created_at: Time.now ) }
    let(:v3) { Video.create( title: "Inception", description: "This is a description 3.", created_at: Time.now + 1) }

    it 'should return an array of one video for an exact match' do
      results = Video.search_by_title( "Inception" )
      expect(results).to eq([v3])
    end

    it 'should return array of videos with that contains the search term ordered by created_at desc' do
      results = Video.search_by_title( "man" )
      expect(results).to eq( [v2, v1] )
    end

    it 'should return an empty array if no match with search term' do
      results = Video.search_by_title( "haha" )
      expect(results).to eq([])
    end

    it 'returns an empty array if the search term is an empty string' do
      results = Video.search_by_title( "" )
      expect(results).to eq([])
    end
  end

  describe 'average_rating' do
    let(:video) { Fabricate(:video) }
    
    it 'returns 0 if there are no reviews' do
      expect(video.average_rating).to eq 0
    end
    it 'returns n if there is 1 review with rating n' do
      review = Fabricate(:review)
      video.reviews << review
      expect(Video.first.average_rating).to eq review.rating
    end
    it 'returns sum(r_i)/n if there are n reviews with rating r_i where r is the rating for review i' do
      reviews = (1..5).each.map { |i| Fabricate(:review, rating: i) }
      video.reviews = reviews
      expect(Video.first.average_rating).to eq 3.0
    end
  end

end