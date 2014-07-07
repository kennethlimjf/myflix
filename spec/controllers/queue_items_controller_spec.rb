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
        Fabricate(:queue_item, video: video, user: current_user)
        post :create, video_id: video.id
        expect(flash[:error]).not_to be_nil
      end

      it 'should render the video show templates with there is an error' do
        Fabricate(:queue_item, video: video, user: current_user)
        post :create, video_id: video.id
        expect(response).to redirect_to video_path(video)
      end
    end
    context 'when user is not authenticated' do
      it 'should redirect to sign in page' do
        post :create
        expect(response).to redirect_to sign_in_path
      end
    end
  end


  describe 'DELETE destroy' do
    let(:current_user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    
    context 'when user is authenticated' do  
      before { session[:user_id] = current_user.id }

      it 'deletes the queue item' do
        qi = Fabricate(:queue_item, video: video, user: current_user)
        delete :destroy, id: qi.id
        expect(QueueItem.all.count).to eq 0
      end
      it 'redirects to the queue page' do
        qi = Fabricate(:queue_item, video: video, user: current_user)
        delete :destroy, id: qi.id
        expect(response).to redirect_to my_queue_path
      end
      it 'reorders queue items' do
        q1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        q2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        q3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        q4 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        delete :destroy, id: q2.id
        expect(q4.reload.list_order).to eq 3
      end
      it 'does not delete other users queue item' do
        u2 = Fabricate(:user)
        q1 = Fabricate(:queue_item, user: u2, video: video)
        delete :destroy, id: q1.id
        expect(u2.queue_items.count).to eq 1
      end
    end
    context 'when user is not authenticated' do
      it 'should redirect to sign in page' do
        qi = Fabricate(:queue_item, video: video, user: current_user)
        delete :destroy, id: qi.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end


  describe 'PATCH update_queue_items' do
    let(:current_user) { Fabricate(:user) }
    let(:category) { Fabricate(:category) }
    let(:v1) { Fabricate(:video, category: category) }
    let(:v2) { Fabricate(:video, category: category) }
    let(:v3) { Fabricate(:video, category: category) }
    let(:v4) { Fabricate(:video, category: category) }
    let(:v5) { Fabricate(:video, category: category) }
    let(:q1) { Fabricate(:queue_item, video: v1, user: current_user, list_order: 1) }
    let(:q2) { Fabricate(:queue_item, video: v2, user: current_user, list_order: 2) }
    let(:q3) { Fabricate(:queue_item, video: v3, user: current_user, list_order: 3) }
    let(:q4) { Fabricate(:queue_item, video: v4, user: current_user, list_order: 4) }
    let(:q5) { Fabricate(:queue_item, video: v5, user: current_user, list_order: 5) }

    context 'when user is authenticated' do  
      before { session[:user_id] = current_user.id }
      it 'redirect to my queue' do
        patch :update_queue_items, { "queue_items"=>{"1"=>"1", "3"=>"2", "7"=>"3", "9"=>"4", "10"=>"5"} }
        expect(response).to redirect_to my_queue_path
      end

      it 'receives params' do
        patch :update_queue_items, { "queue_items"=>{"1"=>"1", "3"=>"2", "7"=>"3", "9"=>"4", "10"=>"5"} }
        expect(assigns(:queue_items)).to eq ({"1"=>"1", "3"=>"2", "7"=>"3", "9"=>"4", "10"=>"5"})
      end

      it 'flash notice when inputs are valid' do
        patch :update_queue_items, { "queue_items"=>{"1"=>"5", "3"=>"4", "7"=>"3", "9"=>"2", "10"=>"1"} }
        expect(flash[:notice]).not_to be_nil
      end

      it 'flash error when inputs are invalid' do
        current_user.queue_items = [q1,q2,q3,q4,q5]
        patch :update_queue_items, { "queue_items"=>{"1"=>"5", "3"=>"5", "7"=>"5", "9"=>"2", "10"=>"1"} }
        expect(flash[:error]).not_to be_nil
      end
    end
  end

end