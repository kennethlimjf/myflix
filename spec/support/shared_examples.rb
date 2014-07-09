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
    sign_in
    action
    expect(response).to redirect_to root_path
  end
end