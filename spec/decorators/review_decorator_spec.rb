require 'spec_helper'

describe ReviewDecorator do
  
  describe '#rating' do
    it 'displays rating out of 5.0 for a review' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Review.create(rating: 3, body: "Some text...", video: video, author: user)
      rd = review.decorate
      expect(rd.rating).to eq "3.0 / 5.0"
    end
  end

end