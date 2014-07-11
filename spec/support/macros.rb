def sign_in
  user = Fabricate(:user)
  session[:user_id] = user.id
end

def set_current_user(user)
  session[:user_id] = user.id
end

def current_user
  User.find(session[:user_id]) if session[:user_id]
end

def sign_out
  session[:user_id] = nil
end

def user_sign_in(user)
  visit '/sign-in'
  fill_in :email, with: user.email
  fill_in :password, with: user.password
  click_button "Sign in" 
end

def user_sign_out
  click_link "Sign Out"
end
