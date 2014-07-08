require 'spec_helper'

feature 'User sign in' do

  background { Fabricate(:user, email: "jessica@example.com", password: "password", full_name: "Jessica") }

  scenario 'User signs in' do
    visit '/sign-in'
    fill_in :email, with: "jessica@example.com"
    fill_in :password, with: "password"
    click_button "Sign in"

    expect(page).to have_content "Welcome, Jessica"
  end

end