require 'spec_helper'

describe VideosController do

  let(:video) { Fabricate(:video) }

  describe 'GET show' do
    before { sign_in }
    
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

    it_behaves_like 'require sign in' do
      let(:action) { get :show, id: 1 } 
    end
  end


  describe 'GET search' do
    before { sign_in }
    
    it 'receives params[:search_term]' do
      get :search, search_term: "lorem"
      expect(request.params[:search_term]).to eq "lorem"
    end
    
    it 'sets the @results variable' do
      get :search, search_term: video.title
      expect(assigns(:results)).to eq [video]
    end

    it_behaves_like 'require sign in' do
      let(:action) { get :search, search_term: "lorem" } 
    end
  end

end