shared_examples 'require sign in' do
  it 'redirects to the sign in page' do
    sign_out
    action
    expect(response).to redirect_to sign_in_path
  end

  it 'flash notice' do
    sign_out
    action
    expect(flash[:notice]).not_to be_nil
  end
end


shared_examples 'require user be signed out' do
  it 'redirects to root path if user is signed in' do
    set_current_user Fabricate(:user)
    action
    expect(response).to redirect_to root_path
  end
end


shared_examples 'require admin' do
  it 'allows admin to access admin area' do
    set_current_user Fabricate(:user, admin: true)
    action
    expect(response.status).to be_truthy
  end

  it 'redirects to root path if user access admin area' do
    set_current_user Fabricate(:user)
    action
    expect(response).to redirect_to root_path
  end

  it 'flash error if user access admin area' do
    set_current_user Fabricate(:user)
    action
    expect(flash[:error]).to be_present
  end

  it 'redirects to the sign in page when not signed in' do
    sign_out
    action
    expect(response).to redirect_to sign_in_path
  end
end


shared_examples 'tokenable' do
  it 'should be able to generate token for object model' do
    object.generate_token
    expect(object.reload.token).not_to be_nil
  end

  it 'clears token for object model' do
    object.generate_token
    object.clear_token
    expect(object.reload.token).to be_nil
  end
end