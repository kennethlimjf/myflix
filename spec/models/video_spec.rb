require 'spec_helper'

describe 'Video' do
  it 'should save' do
    video = Video.new(  title: "The Amazing Spiderman",
                        description: "An EPIC adventure of how man transformed into a spider..." )
    video.save

    Video.find(video.id).should_not be_nil
  end

  it 'belongs to a category' do
    c = Category.create( name: "Dramas" )
    v = Video.create( title: "Video 1", description: "This is a description for video 1.", category: c )

    expect(v.category.name).to eq('Dramas')
  end
end