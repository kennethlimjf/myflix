require 'spec_helper'

feature 'User forgets password' do

  background { clear_emails }
  let(:user) { Fabricate(:user, email: "test@test.com", password: "testtest", full_name: "Tester") }

  scenario 'User forgets password and resets password' do
    visit_forgot_password_email_trigger user.email
    
    open_email user.email
    expect(current_email.body).to have_content "Password Reset"

    current_email.click_link 'Click here to reset your password'
    expect(page).to have_content "Reset Your Password"

    new_password = "testing123"
    set_new_password new_password
    expect(page).to have_content "User account password has been updated."

    sign_in user.email, new_password
    expect(page).to have_content "Welcome, #{user.full_name}"
  end


  scenario 'User forgets password and fails to reset to short invalid password' do
    visit_forgot_password_email_trigger user.email
    
    open_email user.email
    expect(current_email.body).to have_content "Password Reset"

    current_email.click_link 'Click here to reset your password'
    expect(page).to have_content "Reset Your Password"

    new_password = "short"
    set_new_password new_password
    expect(page).to have_content "Password is too short"
  end


  scenario 'User resets password successfully and cannot use the same token' do
    visit_forgot_password_email_trigger user.email

    open_email user.email
    current_email.click_link 'Click here to reset your password'
    
    new_password = "testing123"
    set_new_password new_password
    expect(page).to have_content "User account password has been updated."

    current_email.click_link 'Click here to reset your password'
    expect(page).not_to have_content "Reset Your Password"
  end


  def visit_forgot_password_email_trigger(email)
    visit '/sign-in'
    click_link 'Forgot Password'
    fill_in :email, with: email
    click_on 'Send Email'
  end


  def set_new_password(new_password)
    fill_in :new_password, with: new_password
    click_on "Reset Password"
  end


  def sign_in(email, password)
    visit 'sign-in'
    fill_in :email, with: email
    fill_in :password, with: password
    click_button 'Sign in'
  end
end