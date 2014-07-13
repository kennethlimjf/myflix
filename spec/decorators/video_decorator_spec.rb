require 'spec_helper'

describe VideoDecorator do
  
  describe '#average_rating' do
    it 'displays average rating out of 5.0 for a review' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Review.create(rating: 3, body: "Some text...", video: video, author: user)
      review = Review.create(rating: 5, body: "Some text...", video: video, author: user)
      vd = video.decorate
      expect(vd.average_rating).to eq "4.0 / 5.0"
    end
  end

end