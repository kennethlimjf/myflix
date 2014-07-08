shared_examples 'require sign in' do
  it 'redirects to the sign in page' do
    sign_out
    action
    expect(response).to redirect_to sign_in_path
  end
end