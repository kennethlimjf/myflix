require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }
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
      qi.save!
      expect(qi.reload.list_order).not_to be_nil
    end
  end

  describe '.update_user_queue_items!' do
    let(:v1) { Fabricate(:video, category: category) }
    let(:v2) { Fabricate(:video, category: category) }
    let(:v3) { Fabricate(:video, category: category) }
    let(:v4) { Fabricate(:video, category: category) }
    let(:v5) { Fabricate(:video, category: category) }
    let(:q1) { Fabricate(:queue_item, video: v1, user: user, list_order: 1) }
    let(:q2) { Fabricate(:queue_item, video: v2, user: user, list_order: 2) }
    let(:q3) { Fabricate(:queue_item, video: v3, user: user, list_order: 3) }
    let(:q4) { Fabricate(:queue_item, video: v4, user: user, list_order: 4) }
    let(:q5) { Fabricate(:queue_item, video: v5, user: user, list_order: 5) }

    context 'on valid input' do
      it 'returns [] when user has no queue items' do
        u2 = Fabricate(:user)
        expect(QueueItem.update_user_queue_items!( user, {"1" => "4"} )).to eq []
      end
      it 'returns [q1] when user has 1 queue item' do
        u2 = Fabricate(:user)
        v1 = Fabricate(:video, category: category)
        q1 = Fabricate(:queue_item, video: v1, user:user, list_order: 1)
        expect(QueueItem.update_user_queue_items!( user, {"1" => "4"} )).to eq [q1]
      end
      it 'returns [q2,q4,q5,q3,q1] when updated to specific order' do
        user.queue_items = [q1,q2,q3,q4,q5]
        queue_params = { v1.id => "5", v2.id => "1", v3.id => "4", v4.id => "2", v5.id => "3"}
        expect(QueueItem.update_user_queue_items!( user, queue_params )).to eq [q2,q4,q5,q3,q1]
      end
    end

    context 'on invalid input' do
      it 'rollback to original [q1,q2,q3,q4,q5] when updated to specific invalid order' do
        user.queue_items = [q1,q2,q3,q4,q5]
        queue_params = { v1.id => "5", v2.id => "1", v3.id => "4", v4.id => "5", v5.id => "3"}
        QueueItem.update_user_queue_items!( user, queue_params )
        expect(user.queue_items).to eq [q1,q2,q3,q4,q5]
      end
      it 'returns nil' do
        user.queue_items = [q1,q2,q3,q4,q5]
        queue_params = { v1.id => "5", v2.id => "1", v3.id => "4", v4.id => "5", v5.id => "3"}
        expect(QueueItem.update_user_queue_items!( user, queue_params )).to be_nil
      end
    end
  end

end