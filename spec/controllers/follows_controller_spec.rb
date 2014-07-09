require 'spec_helper'
require 'pry'

describe FollowsController do

  before { sign_in }

  describe 'GET index' do
    it 'should set the @follows variable' do
      get :index
      expect(assigns(:follow_users)).not_to be_nil
    end

    it_behaves_like 'require sign in' do
      let(:action) { get :index }
    end
  end

  describe 'DELETE destroy' do
    it 'should redirect to follow path (index)' do
      delete :destroy, id: 1
      expect(response).to redirect_to people_path
    end

    it 'unfollows the user' do
      user = User.find(session[:user_id])
      u1 = Fabricate(:user)
      user.follow(u1)
      delete :destroy, id: u1.id
      expect(user.follow_users.count).to eq 0 
    end

    it 'does not unfollow if it is not the current user' do
      user = User.find(session[:user_id])
      u1 = Fabricate(:user)
      u2 = Fabricate(:user)
      u1.follow u2
      u2.follow u1

      user.unfollow u1
      user.unfollow u2
      ary = u1.follow_users + u2.follow_users

      expect(ary).to eq([u2, u1])
    end

    it_behaves_like 'require sign in' do
      let(:action) { delete :destroy, id: 1 }
    end
  end

end