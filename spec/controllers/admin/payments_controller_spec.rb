require 'spec_helper'

describe Admin::PaymentsController do

  describe 'GET index' do
    it 'sets the @payments variable' do
      admin = Fabricate(:user, admin: true)
      set_current_user(admin)
      get :index
      expect(assigns(:payments)).to eq Payment.all
    end
  end

  it_behaves_like 'require admin' do
    let(:action) { get :index }
  end

end