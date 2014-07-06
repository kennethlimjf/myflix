require 'spec_helper'

describe ReviewsController do
  
  describe 'POST create' do

    let(:video) { Fabricate(:video) }

    it 'receives params video_id' do
      post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
      expect(request.params[:video_id]).not_to be_nil
    end

    it 'receives params review' do
      post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
      expect(request.params[:review]).not_to be_nil
    end

    context 'when user is authenticated' do
      before { session[:user_id] = Fabricate(:user).id }
      
      context 'when inputs are valid' do
        before do
          post :create, video_id: video.id, review: { rating: 4, body: "some text..." }
        end
        it 'saves the review object' do
          expect(Review.all.count).to eq 1
        end
        it 'flash notice' do
          expect(flash[:notice]).not_to be_nil
        end
        it 'redirects to the current video page' do
          expect(response).to redirect_to video_path(video)
        end
      end

      context 'when inputs are invalid' do
        it 'flash error' do
          post :create, video_id: video.id, review: { rating: 4, body: nil }
          expect(flash[:error]).not_to be_nil
        end
        it 'sets the @review rating variable if available' do
          post :create, video_id: video.id, review: { rating: 4, body: nil }
          expect(assigns(:review).rating).to eq 4
        end
        it 'sets the @review body variable if available' do
          post :create, video_id: video.id, review: { rating: nil, body: "Some text..." }
          expect(assigns(:review).body).to eq "Some text..."
        end
        it 'sets the @video variable' do
          post :create, video_id: video.id, review: { rating: nil, body: "Some text..." }
          expect(assigns(:video)).to eq video
        end
        it 'renders the show template for video' do
          post :create, video_id: video.id, review: { rating: nil, body: nil }
          expect(response).to render_template "videos/show"
        end
      end
    end # End of "when user is authenticated"

    context 'when user is not authenticated' do
      it 'should redirect to sign in path' do
        post :create, video_id: video.id, review: { rating: 4, body: "some text..." }
        expect(response).to redirect_to sign_in_path
      end
    end # End of "when user is not authenticated"
  end

end