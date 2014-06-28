require 'spec_helper'

describe 'Video' do
  it 'should save' do
    video = Video.new(  title: "The Amazing Spiderman",
                        description: "An EPIC adventure of how man transformed into a spider..." )
    video.save

    Video.find(video.id).should_not be_nil
  end
end