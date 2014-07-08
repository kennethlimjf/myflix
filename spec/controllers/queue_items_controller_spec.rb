require 'spec_helper'

describe QueueItemsController do

  describe 'GET index' do
    
    before { sign_in }
    
    it 'should render template for index' do
      get :index
      expect(response).to render_template :index
    end
    
    it 'should set queue items variable' do
      get :index
      expect(assigns(:queue_items)).not_to be_nil
    end
    
    it_behaves_like 'require sign in' do
      let(:action) { get :index }
    end

  end



  describe 'POST create' do
      
    before { sign_in }
    let(:video) { Fabricate(:video) }

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
  
    it_behaves_like 'require sign in' do
      let(:action) { post :create, video_id: video.id }
    end
    
  end


  describe 'DELETE destroy' do
    
    before { sign_in }
    let(:video) { Fabricate(:video) }
    let(:qi) { Fabricate(:queue_item, video: video, user: current_user) }

    it 'deletes the queue item' do
      delete :destroy, id: qi.id
      expect(QueueItem.all.count).to eq 0
    end

    it 'redirects to the queue page' do
      delete :destroy, id: qi.id
      expect(response).to redirect_to my_queue_path
    end

    it 'reorders queue items' do
      current_user.queue_items = []
      4.times { Fabricate(:queue_item, video: Fabricate(:video), user: current_user) }
      delete :destroy, id: 2
      expect(current_user.queue_items.last.list_order).to eq 3
    end

    it 'does not delete other users queue item' do
      another_user = Fabricate(:user)
      q1 = Fabricate(:queue_item, user: another_user, video: video)
      delete :destroy, id: q1.id
      expect(another_user.queue_items.count).to eq 1
    end

    it_behaves_like 'require sign in' do
      let(:action) { delete :destroy, id: 1 }
    end
    
  end


  describe 'PATCH update_queue_items' do

    before { sign_in }
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
    let(:q_params) { { "queue_items" => [ {"id"=>"10", "list_order"=>"1", "rating"=>"4"},
                                          {"id"=>"3", "list_order"=>"1", "rating"=>""},
                                          {"id"=>"7", "list_order"=>"1", "rating"=>""},
                                          {"id"=>"9", "list_order"=>"1", "rating"=>""},
                                          {"id"=>"1", "list_order"=>"1", "rating"=>"1"}] } }

    it 'redirect to my queue' do
      patch :update_queue_items, q_params
      expect(response).to redirect_to my_queue_path
    end

    it 'receives params' do
      patch :update_queue_items, q_params
      expect(assigns(:queue_items)).to eq q_params["queue_items"]
    end

    it 'flash notice when inputs are valid' do
      patch :update_queue_items, q_params
      expect(flash[:notice]).not_to be_nil
    end

    it 'flash error when inputs are invalid' do
      current_user.queue_items = [q1,q2,q3,q4,q5]
      q_params["queue_items"].each { |h| h["list_order"] = 1 }
      patch :update_queue_items, q_params
      expect(flash[:error]).not_to be_nil
    end

    it_behaves_like 'require sign in' do
      let(:action) { patch :update_queue_items, q_params }
    end

  end

end