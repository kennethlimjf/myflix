require 'spec_helper'

describe InvitationsController do

  describe 'GET new' do
    before { sign_in }

    it 'sets the @invitation variable' do
      get :new
      expect(assigns(:invitation)).to be_new_record
    end

    it 'sets the default message for @invitation' do      
      get :new
      expect(assigns(:invitation).message).to eq "Please join this really cool site!"
    end

    it_behaves_like 'require sign in' do
      let(:action) { get :new }
    end
  end

  describe 'POST create' do
    before { sign_in }
    after { ActionMailer::Base.deliveries.clear }
    let(:submit_valid_post) { post :create, invitation: { name: "Taylor Swift", email: "taylor@swift.com", message: "Join me!" } }

    it 'redirects user to root path' do
      submit_valid_post
      expect(response).to redirect_to root_path
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
      post :create, invitation: { name: "", email: "taylor@swift.com", message: "Join me!" }
      expect(flash[:error]).not_to be_nil
    end

    it 'flash error when there is no friend email' do
      post :create, invitation: { name: "", email: "taylor@swift.com", message: "Join me!" }
      expect(flash[:error]).not_to be_nil
    end
    it 'flash error when there is no message' do
      post :create, invitation: { name: "Taylor Swift", email: "taylor@swift.com", message: "" }
      expect(flash[:error]).not_to be_nil
    end
    it 'does not send email if there is an error with form' do
      post :create, invitation: { name: "Taylor Swift", email: "", message: "Join me!" }
      expect(ActionMailer::Base.deliveries.count).to eq 0
    end

    it 'render invite page when there is an error' do
      post :create, invitation: { name: "Taylor Swift", email: "", message: "Join me!" }
      expect(response).to render_template :new
    end
  end

end