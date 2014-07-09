require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    it 'should set the @user variable' do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end

  describe 'POST create' do
    it 'receives params[:user]' do
      post :create, user: { email: "admin@admin.com", password: "adminadmin", full_name: "Admin" }
      expect(request.params[:user]).to eq( {"email"=>"admin@admin.com", "password"=>"adminadmin", "full_name"=>"Admin"} )
    end

    context 'if new user form input is valid' do
      before { post :create, user: { email: "admin@admin.com", password: "adminadmin", full_name: "Admin" } }
      it 'flash notice if user saves' do
        expect(flash[:notice]).to eq "Your new account has been created."
      end
      it 'redirects to root_path if user saves' do
        expect(response).to redirect_to root_path
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

end