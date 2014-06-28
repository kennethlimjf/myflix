require 'spec_helper'

describe 'Category' do
  it 'should save' do
    c = Category.new( name: "TV Comedy" )
    c.save

    expect(Category.all.first).to eq(c)
  end

  it 'should be able to contain many videos' do
    c = Category.create( name: "News" )

    v1 = Video.create( title: "Z Video", description: "This is a description for video 1.", category: c )
    v2 = Video.create( title: "A Video", description: "This is a description for video 2.", category: c )

    expect(c.videos).to eq([v2, v1])
  end
end