require 'spec_helper'

describe 'Category' do
  it 'should save' do
    c = Category.new( name: "TV Comedy" )
    c.save

    expect(Category.all.first).to eq(c)
  end

  it 'should be able to contain many videos' do
    v1 = Video.create( title: "Video 1", description: "This is a description for video 1." )
    v2 = Video.create( title: "Video 2", description: "This is a description for video 2." )

    c = Category.create( name: "News" )
    c.videos << v1
    c.videos << v2

    expect(c.videos.count).to eq(2)
  end
end