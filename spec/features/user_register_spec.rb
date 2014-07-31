require 'spec_helper'

feature 'User registers', :vcr do

  background { visit_register_page }

  given(:valid_card_number) { '4242424242424242' }
  given(:declined_card_number) { '4000000000000002' }
  given(:invalid_card_number) { '4000000000000127' }
   
  scenario 'user input valid and credit card is valid', :js do
    fill_in_valid_user_input
    fill_in_valid_credit_card
    click_button "Sign Up"
    expect(page).to have_content "Your payment was successful. Your account has been created."
  end

  scenario 'user input valid and credit card is valid but declined', :js  do
    fill_in_valid_user_input
    fill_in_declined_credit_card
    click_button "Sign Up"
    expect(page).to have_content "Your card was declined"
  end

  scenario 'user input valid and credit card is invalid', :js  do
    fill_in_valid_user_input
    fill_in_invalid_credit_card
    click_button "Sign Up"
    expect(page).to have_content "Your card's security code is incorrect"
  end

  scenario 'user input valid and credit card is valid', :js do
    fill_in_invalid_user_input
    fill_in_valid_credit_card
    click_button "Sign Up"
    expect(page).to have_content "Please fill up the form correctly"
  end

  scenario 'user input valid and credit card is valid but declined', :js  do
    fill_in_invalid_user_input
    fill_in_declined_credit_card
    click_button "Sign Up"
    expect(page).to have_content "Please fill up the form correctly"
  end

  scenario 'user input valid and credit card is invalid', :js  do
    fill_in_invalid_user_input
    fill_in_invalid_credit_card
    click_button "Sign Up"
    expect(page).to have_content "Please fill up the form correctly"
  end


  def set_stripe_publishable_key
    page.execute_script("Stripe.setPublishableKey(\"#{Rails.configuration.stripe[:publishable_key]}\");")
  end

  def visit_register_page
    visit '/register'
    set_stripe_publishable_key
  end

  def fill_in_valid_user_input
    fill_in "Email Address", with: "alice@gmail.com"
    fill_in "Password", with: "alice123"
    fill_in "Full Name", with: "Alice"
  end

  def fill_in_invalid_user_input
    fill_in "Email Address", with: "alice@gmail.com"
    fill_in "Password", with: "aaa"
    fill_in "Full Name", with: ""
  end

  def fill_in_valid_credit_card
    fill_in "Credit Card Number", with: valid_card_number
    fill_in "Security Code", with: 123
    select "10 - October", from: "date[month]"
    select "2015", from: "date[year]"
  end

  def fill_in_declined_credit_card
    fill_in "Credit Card Number", with: declined_card_number
    fill_in "Security Code", with: 123
    select "10 - October", from: "date[month]"
    select "2015", from: "date[year]"
  end

  def fill_in_invalid_credit_card
    fill_in "Credit Card Number", with: invalid_card_number
    fill_in "Security Code", with: 123
    select "10 - October", from: "date[month]"
    select "2015", from: "date[year]"
  end
end