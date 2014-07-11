require 'spec_helper'

describe CoverUploader do
  include CarrierWave::Test::Matchers

  before do
    @uploader = CoverUploader.new(@video, :cover)
    @uploader.store!(File.open("#{Rails.root}/spec/test_images/test.jpg"))
  end

  after do
    @uploader.remove!
  end

  it 'should store image' do
    @uploader.should_not be_nil
  end
end