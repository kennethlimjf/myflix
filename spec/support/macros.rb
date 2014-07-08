def sign_in
  user = Fabricate(:user)
  session[:user_id] = user.id
end

def current_user
  User.find(session[:user_id]) if session[:user_id]
end

def sign_out
  session[:user_id] = nil
end