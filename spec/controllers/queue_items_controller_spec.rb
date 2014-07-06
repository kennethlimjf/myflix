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
end