require 'spec_helper'

describe User do

  it { should have_secure_password }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :password }
  it { should validate_confirmation_of :password }
  it { should validate_presence_of :full_name }
  it { should have_many :reviews }
  it { should have_many :queue_items }

  let(:user) { Fabricate(:user) }
  let(:v1) { Fabricate(:video) }
  let(:v2) { Fabricate(:video) }
  let(:v3) { Fabricate(:video) }
  let(:q1) { Fabricate(:queue_item, video: v1, user: user) }
  let(:q2) { Fabricate(:queue_item, video: v2, user: user) }
  let(:q3) { Fabricate(:queue_item, video: v3, user: user) }

  describe '#has_video_in_queue?' do

    it 'returns false when user has no queue items' do
      expect(user.has_video_in_queue?(v1)).to be_falsey
    end

    it 'returns false when user has no matching video in queue' do
      user.queue_items << q1
      user.queue_items << q2

      expect(user.has_video_in_queue?(v3)).to be_falsey
    end

    it 'returns true when video is found in user queue' do
      user.queue_items << q1
      user.queue_items << q2
      user.queue_items << q3

      expect(user.has_video_in_queue?(v3)).to be_truthy
    end

  end


  describe '#videos_count' do

    it 'returns the number of videos in the user queue' do
      user.queue_items << q1
      user.queue_items << q2
      user.queue_items << q3
      expect(user.videos_count).to eq 3
    end

  end
  
end