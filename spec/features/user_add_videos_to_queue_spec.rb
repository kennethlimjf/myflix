require 'spec_helper'

feature 'User add videos to queue' do
  
  background { user_sign_in(user) }
  let!(:user) { Fabricate(:user, email: "a@a.com", password: "password", full_name: "Alice") }

  scenario 'signed in user should see welcome' do
    visit '/'
    expect(page).to have_content "Welcome, #{user.full_name}"
  end

  scenario 'signed in user should be at home path' do
    visit '/'
    expect(current_path).to eq home_path
  end

  scenario 'user clicks and views video content from home page' do

    category = Fabricate(:category)
    south_park = Fabricate(:video, title: "South Park", category: category)
    iron_man = Fabricate(:video, title: "Iron Man", category: category)
    ip_man = Fabricate(:video, title: "Ip Man", category: category)
    spiderman = Fabricate(:video, title: "The Amazing Spiderman", category: category)

    add_video_to_queue(south_park)    
    expect_queue_to_have south_park

    click_link "South Park"
    expect(page).not_to have_link "+ My Queue"

    add_video_to_queue(iron_man)
    add_video_to_queue(ip_man)
    add_video_to_queue(spiderman)

    expect_queue_to_have south_park
    expect_queue_to_have iron_man
    expect_queue_to_have ip_man
    expect_queue_to_have spiderman

    set_list_order(south_park, 4)
    set_list_order(iron_man, 3)
    set_list_order(ip_man, 2)
    set_list_order(spiderman, 1)

    click_button "Update Instant Queue"

    expect_order_to_be(south_park, 4)
    expect_order_to_be(iron_man, 3)
    expect_order_to_be(ip_man, 2)
    expect_order_to_be(spiderman, 1)
    
  end

  def add_video_to_queue(video)
    visit '/'
    find("#video-link-#{video.id}").click
    click_link "+ My Queue"
  end

  def expect_queue_to_have(video)
    visit '/my-queue'
    expect(page).to have_content video.title
  end

  def set_list_order(video, value)
    find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").set value
  end

  def expect_order_to_be(video, order)
    find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value.should == order.to_s
  end

end