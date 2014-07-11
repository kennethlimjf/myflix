require 'spec_helper'

describe CoverUploader do
  include CarrierWave::Test::Matchers

  before do
    CoverUploader.enable_processing = true
    @uploader = CoverUploader.new(@video, :cover)
    @uploader.store!(File.open("#{Rails.root}/spec/test_images/test.jpg"))
  end

  after do
    CoverUploader.enable_processing = false
    @uploader.remove!
  end
  
  context 'the small version' do
    it "should scale down a landscape image to fit within 166 by 236 pixels" do
      @uploader.small.should be_no_larger_than(166, 236)
    end
  end

  it 'should store image' do
    @uploader.should_not be_nil
  end
end