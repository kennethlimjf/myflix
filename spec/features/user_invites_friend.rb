require 'spec_helper'

feature 'User invites friend' do 
  scenario 'Alice invites bob to MyFlix, Bob registers an account with token' do
    alice = Fabricate(:user)
    bob_name = "Bob"
    bob_email = "bob@gmail.com"
    bob_password = "password"

    user_sign_in alice
    visit '/'
    click_on 'Invite a Friend'

    fill_in "Friend's Name", with: bob_name
    fill_in "Friend's Email Address", with: bob_email
    fill_in "Invitation Message", with: "Join the site!"
    click_button "Send Invitation"
    user_sign_out

    open_email bob_email
    expect(current_email.body).to have_content "Bob"

    current_email.click_link "Join Us"
    fill_in "Password", with: bob_password
    fill_in "Full Name", with: bob_name
    click_button 'Sign Up'
    expect(page).to have_content "Your new account has been created"

    visit '/sign-in'
    fill_in :email, with: bob_email
    fill_in :password, with: bob_password
    click_button "Sign in" 

    expect(page).to have_content "Welcome, #{bob_name}"
  end
end