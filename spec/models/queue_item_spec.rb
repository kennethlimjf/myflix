require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :list_order }

  describe 'user_rating' do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    let(:qi) { Fabricate(:queue_item, video: video, user: user) } 
    it 'returns unrated when there is 0 user review' do
      expect(qi.user_rating).to eq nil
    end
    it 'returns rating when there is one review' do
      r1 = Fabricate(:review, author: user, video: video, rating: 3)
      expect(qi.user_rating).to eq 3
    end
    it 'returns the latest rating when there is more than one review' do
      time = Time.now
      r1 = Fabricate(:review, author: user, video: video, rating: 1, created_at: time)
      r2 = Fabricate(:review, author: user, video: video, rating: 2, created_at: time+1)
      r3 = Fabricate(:review, author: user, video: video, rating: 3, created_at: time+2)
      r4 = Fabricate(:review, author: user, video: video, rating: 4, created_at: time+3)
      r5 = Fabricate(:review, author: user, video: video, rating: 5, created_at: time+4)
      expect(qi.user_rating).to eq 5
    end
  end
end