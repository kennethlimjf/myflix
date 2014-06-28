require 'spec_helper'

describe Category do

  it { should have_many(:videos).order('title ASC') }

  describe '#recent_videos' do
    let(:time) { Time.now }
    let(:c1) { Category.create( name: "TV Dramas" ) }
    let(:c2) { Category.create( name: "Movies" ) }
    let(:c3) { Category.create( name: "Documentary" ) }
    let(:v1) { Video.create(title: "Video 1 C2", description: "This is a description.", category: c2, created_at: time) }
    let(:v2) { Video.create(title: "Video 2 C2", description: "This is a description.", category: c2, created_at: time + 1) }
    let(:v3) { Video.create(title: "Video 3 C2", description: "This is a description.", category: c2, created_at: time + 2) }
    let(:v4) { Video.create(title: "Video 4 C2", description: "This is a description.", category: c2, created_at: time + 3) }
    let(:v5) { Video.create(title: "Video 1 C3", description: "This is a description.", category: c3, created_at: time + 4) }
    let(:v6) { Video.create(title: "Video 2 C3", description: "This is a description.", category: c3, created_at: time + 5) }
    let(:v7) { Video.create(title: "Video 3 C3", description: "This is a description.", category: c3, created_at: time + 6) }
    let(:v8) { Video.create(title: "Video 4 C3", description: "This is a description.", category: c3, created_at: time + 7) }
    let(:v9) { Video.create(title: "Video 5 C3", description: "This is a description.", category: c3, created_at: time + 8) }
    let(:v10) { Video.create(title: "Video 6 C3", description: "This is a description.", category: c3, created_at: time + 9) }
    let(:v11) { Video.create(title: "Video 7 C3", description: "This is a description.", category: c3, created_at: time + 10) }
    let(:v12) { Video.create(title: "Video 8 C3", description: "This is a description.", category: c3, created_at: time + 11) }
    let(:v13) { Video.create(title: "Video 9 C3", description: "This is a description.", category: c3, created_at: time + 12) }

    it 'return an empty array if there is no video for category' do
      expect(c1.recent_videos).to eq([])
    end

    it 'return an array of all videos if there are less than 6 videos in the category in created_at descending order' do
      expect(c2.recent_videos).to eq([v4, v3, v2, v1])
    end

    it 'return an array of 6 videos if there are more than or equal to 6 videos for the category in created_at descending order' do
      expect(c3.recent_videos).to eq([v13, v12, v11, v10, v9, v8])
    end
  end

end