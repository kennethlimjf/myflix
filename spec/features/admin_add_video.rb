require 'spec_helper'

feature 'Admin adds video' do
  scenario 'Admin adds video and user watchs video' do
    category = Fabricate(:category)

    admin = Fabricate(:user, admin: true)
    user_sign_in admin
    click_link "Add New Video"

    video_url = "https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4"
    fill_in "Title", with: "Video 1"
    fill_in "Description", with: "Some description"
    select category.name, from: "Category"
    attach_file "Video Cover", "spec/test_images/test.jpg"
    fill_in "Video URL", with: video_url

    click_button "Add Video"
    expect(page).to have_content "You have added a video"
    expect(Video.all.count).to eq 1
    user_sign_out
    
    user = Fabricate(:user)
    user_sign_in user

    find("#video-link-1").click
    expect(page).to have_content "Video 1"
    expect(page).to have_selector "a[href=\"#{video_url}\"]"
  end 
end