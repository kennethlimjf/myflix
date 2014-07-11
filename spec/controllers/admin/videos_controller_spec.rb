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

    it_behaves_like 'require admin' do
      let(:action) { get :new }
    end
  end


  describe 'POST create' do
    before { set_current_user(admin) }
    let(:admin) { Fabricate(:user, admin: true) }
    let(:post_valid_create) { post :create, video: Fabricate.attributes_for(:video) }
    let(:post_invalid_create) { post :create, video: { title: nil, description: nil, category_id: nil } }

    it 'should redirect_to add new video page when added video' do
      post_valid_create
      expect(response).to redirect_to new_admin_video_path
    end

    it 'flash notice when added video' do
      post_valid_create
      expect(flash[:notice]).to be_present
    end

    it 'should render add new video page when fail to add video' do
      post_invalid_create
      expect(response).to render_template :new
    end

    it 'flash errors when fail to add video' do
      post_invalid_create
      expect(flash[:error]).to be_present
    end

    it 'set @categories variable when fail to add video' do
      Fabricate(:category)
      post_invalid_create      
      expect(assigns(:categories)).to be_present
    end

    it_behaves_like 'require admin' do
      let(:action) { post :create, video: Fabricate.attributes_for(:video) }
    end
  end
end