require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it 'shows page when signed in as admin' do
      admin = Fabricate(:user, admin: true)
      set_current_user(admin)
      get :new
      expect(response).to render_template :new
    end

    it 'redirects to root when signed in as user' do
      user = Fabricate(:user)
      set_current_user(user)
      get :new
      expect(response).to redirect_to root_path
    end

    it 'flash error when signed in as user' do
      user = Fabricate(:user)
      set_current_user(user)
      get :new
      expect(flash[:error]).to be_truthy
    end

    it 'redirects to sign in path when not signed in' do
      get :new
      expect(response).to redirect_to sign_in_path
    end

    it 'sets the @video variable' do
      admin = Fabricate(:user, admin: true)
      set_current_user(admin)
      get :new
      expect(assigns(:video)).to be_new_record
    end

    it 'sets the @categories variable' do
      admin = Fabricate(:user, admin: true)
      set_current_user(admin)
      get :new
      expect(assigns(:categories)).to eq Category.all
    end
  end
end