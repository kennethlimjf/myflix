require 'spec_helper'

describe SessionsController do
  
  describe 'GET new' do
    it 'redirects to home_path when the user is already authenicated' do
      sign_in
      get :new
      expect(response).to redirect_to home_path
    end
    it 'renders the new template when user is not authenicated' do
      sign_out
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do

    let(:user) { Fabricate(:user, email: "admin@admin.com", password: "password") }
    let(:invalid_user) { Fabricate(:user, email: "admin@admin.com", password: "password", status: false) }

    it 'receives the params email' do
      post :create, { email: "admin@admin.com", password: "password" }
      expect(request.params[:email]).to eq user.email
    end
    it 'receives the params password' do
      post :create, { email: user.email, password: user.password }
      expect(request.params[:password]).to eq user.password
    end

    context 'when user authentication is successful' do

      it 'flash notice if user account status is valid' do
        post :create, { email: user.email, password: user.password }
        expect(flash[:notice]).to eq "You have successfully signed in."
      end
      it 'redirects to home_path if user account status is valid' do
        post :create, { email: user.email, password: user.password }
        expect(response).to redirect_to home_path
      end

      it 'flash error if user account status is invalid' do
        post :create, { email: invalid_user.email, password: invalid_user.password }
        expect(flash[:error]).to be_present
      end
      it 'renders new template if user account status is invalid' do
        post :create, { email: invalid_user.email, password: invalid_user.password }
        expect(response).to render_template :new
      end
    end
    
    context 'when user authentication is unsuccessful' do
      before { post :create, { email: "asd.asd.com", password: "asdasdasd" } }
      it 'flash error' do
        expect(flash[:error]).to eq "There is a problem with your email and password."
      end
      it 'render the new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE destroy' do
    before { delete :destroy }
    it 'should set session[:user_id] to nil' do
      expect(session[:user_id]).to be_nil
    end
    it 'flash notice' do
      expect(flash[:notice]).to eq "You have successfully signed out."
    end
    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end

end