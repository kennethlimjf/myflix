require 'spec_helper'

describe User do

  it { should have_secure_password }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :password }
  it { should validate_confirmation_of :password }
  it { should ensure_length_of(:password).is_at_least(8) }
  it { should validate_presence_of :full_name }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should have_many(:queue_items).order('list_order ASC') }

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


  describe '#follow_users' do

    it 'should return [] when not following any users' do
      expect(user.follow_users).to eq []
    end

    it 'should return [u1] when following only u1' do
      u1 = Fabricate(:user)
      user.follow_users << u1
      expect(user.follow_users).to eq [u1]
    end

    it 'should return [u2,u1] when following u2 and u1' do
      u1, u2 = Fabricate(:user), Fabricate(:user)
      user.follow_users << [u2, u1]
      expect(user.follow_users).to eq [u2, u1]   
    end

  end

  describe '#followers' do
    it 'returns [] when followed by no one' do
      expect(user.follower_users).to eq []
    end
    it 'returns [u1] when followed by u1' do
      u1 = Fabricate(:user)
      u1.follow_users << user
      expect(user.follower_users).to eq [u1]
    end
  end

  describe '#follow' do
    it 'should add a follow target for user' do
      user.follow(Fabricate(:user))
      expect(user.follow_users.count).to eq 1
    end 

    it 'should add multiple follow target for user' do
      user.follow(Fabricate(:user))
      user.follow(Fabricate(:user))
      user.follow(Fabricate(:user))
      user.follow(Fabricate(:user))
      user.follow(Fabricate(:user))
      expect(user.follow_users.count).to eq 5
    end

    it 'should not add a follow relation if user is already following target' do
      u1 = Fabricate(:user)
      user.follow(u1)
      user.follow(u1)
      expect(user.follow_users.count).to eq 1
    end

    it 'should not add a follow relation to user self' do
      user.follow(user)
      expect(user.follow_users.count).to eq 0
    end
  end

  describe '#unfollow' do
    it 'allows user to unfollow a user after following a user' do
      u1 = Fabricate(:user)
      user.follow(u1)
      user.unfollow(u1)
      expect(user.follow_users.count).to eq 0  
    end

    it 'allows user to unfollow users' do
      u1 = Fabricate(:user)
      u2 = Fabricate(:user)
      u3 = Fabricate(:user)
      user.follow(u1)
      user.follow(u2)
      user.follow(u3)
      user.unfollow(u1)
      user.unfollow(u2)
      expect(user.follow_users).to eq [u3]
    end

    it 'allows user to unfollow users which have not been followed' do
      u1 = Fabricate(:user)
      u2 = Fabricate(:user)
      u3 = Fabricate(:user)
      u4 = Fabricate(:user)
      user.follow(u1)
      user.follow(u2)
      user.follow(u3)
      user.unfollow(u4)
      expect(user.follow_users).to eq [u1,u2,u3]   
    end
  end

  describe '#generate_token' do
    it 'should generate a token for the user' do
      user.generate_token
      expect(user.reload.token).not_to be_nil
    end
  end

  describe '#clear_token' do
    it 'sets token to nil' do      
      user.generate_token
      user.clear_token
      expect(user.reload.token).to be_nil
    end
  end
  
end