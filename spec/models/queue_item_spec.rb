require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :list_order }
  it { should validate_presence_of :video }
  it { should validate_presence_of :user }
  # it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }

  let(:category) { Fabricate(:category) }
  let(:video) { Fabricate(:video, category: category) }
  let(:user) { Fabricate(:user) }
  let(:qi) { Fabricate(:queue_item, video: video, user: user) } 

  describe '#user_rating' do
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

  describe '#video_title' do    
    it 'returns the video title of the queue item' do
      expect(qi.video_title).to eq video.title
    end
  end

  describe '#category_name' do
    it 'returns the category name of the queue item' do
      expect(qi.category_name).to eq video.category.name
    end
  end

  describe '#category' do
    it 'returns the category of the queue item' do
      expect(qi.category).to eq category
    end
  end

  describe '#set_list_order' do
    it 'sets the list order to the last queue item of the user before validation' do
      qi = Fabricate.build(:queue_item, video: video, user: user, list_order: nil)
      qi.save
      expect(qi.list_order).not_to be_nil
    end
  end
end