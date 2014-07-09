require 'spec_helper'

feature 'User follows' do 

  scenario 'User follows and unfollows Alex' do
    current_user = Fabricate(:user)
    alex = Fabricate(:user, full_name: "Alex")
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    review = Fabricate(:review, video: video, author: alex, rating: 5)

    user_sign_in current_user
    navigate_to_video(video)
    
    click_link alex.full_name
    click_button "Follow"
    expect(page).to have_content(alex.full_name)

    unfollow
    expect(page).not_to have_content(alex.full_name)
  end

  def navigate_to_video(video)
    visit '/'
    find("#video-link-#{video.id}").click
  end

  def unfollow
    find("a[data-method='delete']").click
  end
end