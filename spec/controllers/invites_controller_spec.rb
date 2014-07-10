require 'spec_helper'

describe InvitesController do

  describe 'GET new' do
    it_behaves_like 'require sign in' do
      let(:action) { get :new }
    end
  end

  describe 'POST invite_submit' do
    before { sign_in }
    after { ActionMailer::Base.deliveries.clear }
    let(:submit_valid_post) { post :invite_submit, friend_name: "Taylor Swift", friend_email: "taylor@swift.com", message: "Join me!" }

    it 'redirects user to root path' do
      submit_valid_post
      expect(response).to redirect_to root_path
    end

    it 'should receive the param for friend name' do
      submit_valid_post
      expect(controller.params[:friend_name]).not_to be_nil
    end

    it 'should receive the param for friend email address' do
      submit_valid_post
      expect(controller.params[:friend_email]).not_to be_nil
    end

    it 'should receive the param for message' do
      submit_valid_post
      expect(controller.params[:message]).not_to be_nil
    end

    it 'sends email to friend' do
      submit_valid_post
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end

    it 'flash notice to inform user invite has been sent' do
      submit_valid_post
      expect(flash[:notice]).not_to be_nil
    end

    it 'flash error when there is no friend name' do
      post :invite_submit, friend_name: "", friend_email: "taylor@swift.com", message: "Join me!"
      expect(flash[:error]).not_to be_nil
    end

    it 'flash error when there is no friend email' do
      post :invite_submit, friend_name: "Taylor Swift", friend_email: "", message: "Join me!"
      expect(flash[:error]).not_to be_nil
    end
    it 'flash error when there is no message' do
      post :invite_submit, friend_name: "Taylor Swift", friend_email: "taylor@swift.com", message: ""
      expect(flash[:error]).not_to be_nil
    end
    it 'does not send email if there is an error with form' do
      post :invite_submit, friend_name: "Taylor Swift", friend_email: "", message: "Join me!"
      expect(ActionMailer::Base.deliveries.count).to eq 0
    end

    it 'render invite page when there is an error' do
      post :invite_submit, friend_name: "Taylor Swift", message: "Join me!"
      expect(response).to render_template :new
    end
  end

  describe 'GET join' do
    it 'sets the new user record' do
      get :join, email: 'joiner@test.com'
      expect(assigns(:user)).to be_new_record
    end
    
    it 'sets the user email' do
      get :join, email: 'joiner@test.com'
      expect(assigns(:user).email).to eq 'joiner@test.com'
    end

    it 'renders the join template' do
      get :join, email: 'joiner@test.com'
      expect(response).to render_template :join
    end
  end

  describe 'POST join_submit' do

    let(:post_valid_join_submit) { post :join_submit, inviter_email: 'inviter@test.com', user: { email: 'friend@test.com', password: 'password', full_name: "Joiner Smith"} }

    it 'creates new user' do
      post_valid_join_submit
      expect(assigns(:user).persisted?).to be_truthy
    end

    it 'set user to follow inviter' do
      inviter = Fabricate(:user, email: "inviter@test.com")
      post_valid_join_submit
      expect(assigns(:user).follow_users.include?(inviter)).to be_truthy
    end

    it 'set inviter to follow user' do
      inviter = Fabricate(:user, email: "inviter@test.com")
      post_valid_join_submit
      expect(inviter.follow_users.include?(assigns(:user))).to be_truthy
    end
  end

end