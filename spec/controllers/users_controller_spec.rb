require 'spec_helper'

describe UsersController do

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

    after { ActionMailer::Base.deliveries.clear }

    it 'receives params[:user]' do
      post :create, user: { email: "admin@admin.com", password: "adminadmin", full_name: "Admin" }
      expect(request.params[:user]).to eq( {"email"=>"admin@admin.com", "password"=>"adminadmin", "full_name"=>"Admin"} )
    end

    it_behaves_like 'require user be signed out' do
      let(:action) { post :create, user: { email: "admin@admin.com", password: "adminadmin", full_name: "Admin" } }
    end

    context 'if new user form input is valid' do
      before { post :create, user: { email: "admin@admin.com", password: "adminadmin", full_name: "Admin" } }
      it 'flash notice if user saves' do
        expect(flash[:notice]).to eq "Your new account has been created."
      end
      it 'redirects to root_path if user saves' do
        expect(response).to redirect_to root_path
      end
      it 'sends email to user email address' do
        post :create, user: { email: "admin@admin.com", password: "adminadmin", full_name: "Admin" }
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it 'sends an email with the content "welcome"' do
        post :create, user: { email: "admin@admin.com", password: "adminadmin", full_name: "Admin" }
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include('welcome')
      end

      it 'sends an email to the user email' do
        post :create, user: { email: "admin@admin.com", password: "adminadmin", full_name: "Admin" }
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(['admin@admin.com'])
      end
    end


    context 'when new user form input is invalid' do
      before { post :create, user: { email: "admin@admin.com" } }
      it 'flash error if user does not save' do
        expect(flash[:error]).to eq "Please fill up the form correctly"
      end
      it 'sets the @user variable' do
        expect(assigns(:user)).to be_new_record
      end
      it 'sets @user variable object with previous input' do
        expect(assigns(:user).email).to eq 'admin@admin.com'
      end
      it 'renders new template if user does not save' do
        expect(response).to render_template :new
      end
      it 'does not send email' do
        expect(ActionMailer::Base.deliveries.last).to be_nil
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
    after { ActionMailer::Base.deliveries.clear }
    
    it 'should send email to user' do  
      post :forgot_password_submit, email: user.email
      expect(ActionMailer::Base.deliveries).not_to be_empty
    end

    it 'should send the link with the token' do
      post :forgot_password_submit, email: user.email
      message = ActionMailer::Base.deliveries.last
      expect(message.body).to include(user.reload.token)
    end

    it 'redirect to front page' do
      post :forgot_password_submit, email: user.email
      expect(response).to redirect_to root_path
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