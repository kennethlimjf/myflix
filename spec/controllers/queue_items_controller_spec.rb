require 'spec_helper'

describe QueueItemsController do

  describe 'GET index' do
    context 'when user is authenticated' do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      it 'should render template for index' do
        get :index
        expect(response).to render_template :index
      end
      it 'should set queue items variable' do
        get :index
        expect(assigns(:queue_items)).not_to be_nil
      end
    end

    context 'when user is not authenticated' do
      it 'should redirect to sign in page' do
        get :index
        expect(response).to redirect_to sign_in_path
      end
    end
  end


  describe 'POST create' do
    context 'when user is authenticated' do
      let(:current_user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      before { session[:user_id] = current_user.id }

      it 'should redirect to my queue page' do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it 'should create a new queue item object' do
        post :create, video_id: video.id
        expect(assigns(:queue_item).id).not_to be_nil 
      end

      it 'should flash notice' do
        post :create, video_id: video.id
        expect(flash[:notice]).not_to be_nil
      end

      it 'should flash error if there is a problem with saving the new queue item' do
        post :create, video_id: nil
        expect(flash[:error]).not_to be_nil
      end

      it 'should render the video show templates with there is an error' do
        post :create, video_id: nil
        expect(response).to render_template 'videos/show'
      end
    end
    context 'when user is not authenticated' do
      it 'should redirect to sign in page' do
        post :create
        expect(response).to redirect_to sign_in_path
      end
    end
  end

end