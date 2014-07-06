require 'spec_helper'

describe VideosController do

  let(:video) { Fabricate(:video) }

  describe 'GET show' do
    context "when user is authenticated" do
      before { session[:user_id] = Fabricate(:user).id }
      it 'receives params[:id]' do
        get :show, id: video.id
        expect(request.params[:id]).to eq "1"
      end
      it 'sets the @video variable' do
        get :show, id: video.id
        expect(assigns(:video)).to eq video
      end
      it 'sets new review record variable for form' do
        get :show, id: video.id
        expect(assigns(:review)).to be_new_record
      end
    end

    context "when user is not authenticated" do
      it 'should redirect to log in page' do
        get :show, id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe 'GET search' do
    context "when user is authenticated" do
      before { session[:user_id] = Fabricate(:user).id }    
      it 'receives params[:search_term]' do
        get :search, search_term: "lorem"
        expect(request.params[:search_term]).to eq "lorem"
      end
      it 'sets the @results variable' do
        get :search, search_term: video.title
        expect(assigns(:results)).to eq [video]
      end
    end

    context "when user is not authenticated" do
      it 'should redirect to log in page' do
        get :search, search_term: video.title
        expect(response).to redirect_to sign_in_path
      end
    end
  end

end