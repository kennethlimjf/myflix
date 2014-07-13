require 'spec_helper'

describe UsersController do

  let(:dummy_token) { 'dummy_token_id' }

  describe 'GET new' do
    it 'should set the @user variable' do
      get :new
      expect(assigns(:user)).to be_new_record
    end

    it_behaves_like 'require user be signed out' do
      let(:action) { get :new }
    end
  end


  describe 'POST create' do

    let(:post_valid_create) { post :create, user: { email: "admin@admin.com", password: "adminadmin", full_name: "Admin" }, stripeToken: dummy_token }
    let(:post_invalid_create) { post :create, user: { email: "admin@admin.com" }, stripeToken: dummy_token }
    after { ActionMailer::Base.deliveries.clear }

    it_behaves_like 'require user be signed out' do
      let(:action) { post_valid_create }
    end

    context 'when user registration is successful' do
      before do
        user_registration = double('user_registration', successful?: true, process: nil, user: "user")
        UserRegistration.should_receive(:new).and_return(user_registration)
        user_registration.should_receive(:process)
        user_registration.should_receive(:successful?)
      end

      it 'flash notice' do
        post_valid_create
        expect(flash[:notice]).to be_present
      end

      it 'redirect_to root_path' do
        post_valid_create
        expect(response).to redirect_to root_path
      end
    end

    context 'when user registration is unsuccessful' do
      before do
        user_registration = double('user_registration', successful?: false, process: nil, user: "user", error_message: "Some error")
        UserRegistration.should_receive(:new).and_return(user_registration)
        user_registration.should_receive(:process)
        user_registration.should_receive(:successful?)
      end

      it 'flash error' do
        post_valid_create
        expect(flash[:error]).to be_present
      end

      it 'sets @user variable' do
        post_valid_create
        expect(assigns(:user)).to be_present
      end

      it 'redirect_to root_path' do
        post_valid_create
        expect(response).to render_template :new
      end
    end
  end


  describe 'GET show' do
    let(:user) { Fabricate(:user, email: "jenny@abc.com", full_name: "Jenny", password: "password") }

    it 'sets the @user variable' do
      sign_in
      get :show, id: user.id
      expect(assigns(:user)).to eq user
    end

    it_behaves_like 'require sign in' do
      let(:action) { get :show, id: user.id }
    end
  end


  describe 'GET forgot_password' do
    it_behaves_like 'require user be signed out' do
      let(:action) { get :forgot_password }
    end
  end


  describe 'POST forgot_password_submit' do

    let(:user) { Fabricate(:user) }
    let(:post_forgot_password_submit) { post :forgot_password_submit, email: user.email }
    after { ActionMailer::Base.deliveries.clear }

    context 'when forgot password process is successfully' do
      before do
        forgot_password = double('forgot_password', process: nil, successful?: true)
        ForgotPassword.should_receive(:new).and_return(forgot_password)
        forgot_password.should_receive(:process)
        forgot_password.should_receive(:successful?)
        post_forgot_password_submit
      end

      it 'flash notice' do
        expect(flash[:notice]).not_to be_nil
      end

      it 'redirect to front page' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when forgot password process is unsuccessful' do
      before do
        forgot_password = double('forgot_password', process: nil, successful?: false)
        ForgotPassword.should_receive(:new).and_return(forgot_password)
        forgot_password.should_receive(:process)
        forgot_password.should_receive(:successful?)
        post_forgot_password_submit
      end

      it 'flash error' do
        expect(flash[:error]).not_to be_nil
      end

      it 'redirects to forgot password path' do
        expect(response).to redirect_to forgot_password_path
      end
    end

    it_behaves_like 'require user be signed out' do
      let(:action) { post :forgot_password_submit, email: user.email }
    end
  end


  describe 'GET reset_password' do
    let(:user) { Fabricate(:user, email: "admin@admin.com", password: "adminadmin", full_name: "Tester", token: "123") }

    it 'render reset password when it finds a valid token' do
      get :reset_password, token: user.token
      expect(response).to render_template :reset_password
    end

    it 'redirects to root path when it does not find a valid token' do
      get :reset_password, token: 'invalid_token'
      expect(response).to redirect_to root_path
    end

    it_behaves_like 'require user be signed out' do
      let(:action) { get :reset_password, token: user.token }
    end
  end


  describe 'PATCH reset_password_submit' do
    let!(:user) { Fabricate(:user, email: "admin@admin.com", password: "adminadmin", full_name: "Tester", token: "123") }

    it 'redirects to sign in page' do
      patch :reset_password_submit, new_password: "admin123", token: "123"
      expect(response).to redirect_to sign_in_path
    end

    it 'updates user password to new password' do
      patch :reset_password_submit, new_password: "admin123", token: "123"
      expect(User.find_by(email: 'admin@admin.com').try(:authenticate, 'admin123')).to be_truthy
    end
    
    it 'flash notice to tell user password is updated' do
      patch :reset_password_submit, new_password: "admin123", token: "123"
      expect(flash[:notice]).not_to be_nil
    end

    it 'flash error if there is a problem with the password update' do
      patch :reset_password_submit, new_password: "ad23", token: "123"
      expect(flash[:error]).not_to be_nil
    end

    it 'should clear token after password update success' do
      patch :reset_password_submit, new_password: "admin123", token: "123"
      expect(user.reload.token).to be_nil
    end

    it 'should clear token after password update fails' do
      patch :reset_password_submit, new_password: "a3", token: "123"
      user = User.find_by(email: "admin@admin.com")
      expect(user.token).to be_nil
    end

    it_behaves_like 'require user be signed out' do
      let(:action) { patch :reset_password_submit, new_password: "ad23", token: "123" }
    end
  end
  
end