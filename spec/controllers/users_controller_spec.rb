require 'spec_helper'

describe UsersController do

  before do
    token = double('', id: 1)
    Stripe::Token.stub(:create).and_return(token)
  end
  let(:card_number) { "4242424242424242" }
  let(:valid_token) { Stripe::Token.create( :card => { :number => card_number, :exp_month => 7, :exp_year => 2020, :cvc => "123" } ).id }


  describe 'GET new' do
    it 'should set the @user variable' do
      get :new
      expect(assigns(:user)).to be_new_record
    end

    it_behaves_like 'require user be signed out' do
      let(:action) { get :new }
    end
  end

  describe 'POST create' do

    let(:post_valid_create) { post :create, user: { email: "admin@admin.com", password: "adminadmin", full_name: "Admin" }, stripeToken: valid_token }
    let(:post_invalid_create) { post :create, user: { email: "admin@admin.com" }, stripeToken: valid_token }
    after { ActionMailer::Base.deliveries.clear }

    it_behaves_like 'require user be signed out' do
      let(:action) { post_valid_create }
    end

    context 'when user input is valid' do
      context 'charge is successful' do
        before do
          charge = double('charge', successful?: true)
          StripeWrapper::Charge.stub(:create).and_return(charge)
          post_valid_create
        end

        it 'receives params[:user]' do
          expect(request.params[:user]).to eq( {"email"=>"admin@admin.com", "password"=>"adminadmin", "full_name"=>"Admin"} )
        end

        it 'flash notice if user saves' do
          expect(flash[:notice]).to eq "Your payment was successful. Your account has been created."
        end

        it 'redirects to root_path if user saves' do
          expect(response).to redirect_to root_path
        end

        it 'sends email to user email address' do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it 'sends an email with the content "welcome"' do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include('welcome')
        end

        it 'sends an email to the user email' do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq(['admin@admin.com'])
        end
      end

      context 'charge is unsuccessful' do
        before do
          charge = double('charge', successful?: false, error_message: "Card is rejected")
          StripeWrapper::Charge.stub(:create).and_return(charge)
          post_valid_create
        end

        it 'does not create a new user' do
          expect(User.all.count).to eq 0
        end

        it 'flash error' do
          expect(flash[:error]).to be_present
        end

        it 'renders :new template' do
          expect(response).to render_template :new
        end
      end
    end


    context 'when new user form input is invalid' do
      before { post_invalid_create }
      
      it 'flash error if user does not save' do
        expect(flash[:error]).to eq "Please fill up the form correctly"
      end
      
      it 'sets the @user variable' do
        expect(assigns(:user)).to be_new_record
      end
      
      it 'sets @user variable object with previous input' do
        expect(assigns(:user).email).to eq 'admin@admin.com'
      end
      
      it 'renders new template if user does not save' do
        expect(response).to render_template :new
      end
      
      it 'does not send email' do
        expect(ActionMailer::Base.deliveries.last).to be_nil
      end

      it 'does not process any charge to the customer' do
        expect(assigns(:user).valid?).to be_falsey
      end
    end
  end


  describe 'GET show' do
    let(:user) { Fabricate(:user, email: "jenny@abc.com", full_name: "Jenny", password: "password") }

    it 'sets the @user variable' do
      sign_in
      get :show, id: user.id
      expect(assigns(:user)).to eq user
    end

    it_behaves_like 'require sign in' do
      let(:action) { get :show, id: user.id }
    end
  end

  describe 'GET forgot_password' do
    it_behaves_like 'require user be signed out' do
      let(:action) { get :forgot_password }
    end
  end


  describe 'POST forgot_password_submit' do

    let(:user) { Fabricate(:user) }
    after { ActionMailer::Base.deliveries.clear }
    
    it 'flash error when no such email' do
      post :forgot_password_submit, email: "invalid@email.com"
      expect(flash[:error]).not_to be_nil
    end

    it 'redirect to forgot password when no such email' do
      post :forgot_password_submit, email: "invalid@email.com"
      expect(response).to redirect_to forgot_password_path
    end

    it 'should send email to user' do  
      post :forgot_password_submit, email: user.email
      expect(ActionMailer::Base.deliveries).not_to be_empty
    end

    it 'flash notice' do
      post :forgot_password_submit, email: user.email
      expect(flash[:notice]).not_to be_nil
    end

    it 'should send the link with the token' do
      post :forgot_password_submit, email: user.email
      message = ActionMailer::Base.deliveries.last
      expect(message.body).to include(user.reload.token)
    end

    it 'redirect to front page' do
      post :forgot_password_submit, email: user.email
      expect(response).to redirect_to root_path
    end

    it_behaves_like 'require user be signed out' do
      let(:action) { post :forgot_password_submit, email: user.email }
    end
  end


  describe 'GET reset_password' do
    let(:user) { Fabricate(:user, email: "admin@admin.com", password: "adminadmin", full_name: "Tester", token: "123") }

    it 'render reset password when it finds a valid token' do
      get :reset_password, token: user.token
      expect(response).to render_template :reset_password
    end

    it 'redirects to root path when it does not find a valid token' do
      get :reset_password, token: 'invalid_token'
      expect(response).to redirect_to root_path
    end

    it_behaves_like 'require user be signed out' do
      let(:action) { get :reset_password, token: user.token }
    end
  end


  describe 'PATCH reset_password_submit' do
    let!(:user) { Fabricate(:user, email: "admin@admin.com", password: "adminadmin", full_name: "Tester", token: "123") }

    it 'redirects to sign in page' do
      patch :reset_password_submit, new_password: "admin123", token: "123"
      expect(response).to redirect_to sign_in_path
    end

    it 'updates user password to new password' do
      patch :reset_password_submit, new_password: "admin123", token: "123"
      expect(User.find_by(email: 'admin@admin.com').try(:authenticate, 'admin123')).to be_truthy
    end
    
    it 'flash notice to tell user password is updated' do
      patch :reset_password_submit, new_password: "admin123", token: "123"
      expect(flash[:notice]).not_to be_nil
    end

    it 'flash error if there is a problem with the password update' do
      patch :reset_password_submit, new_password: "ad23", token: "123"
      expect(flash[:error]).not_to be_nil
    end

    it 'should clear token after password update success' do
      patch :reset_password_submit, new_password: "admin123", token: "123"
      expect(user.reload.token).to be_nil
    end

    it 'should clear token after password update fails' do
      patch :reset_password_submit, new_password: "a3", token: "123"
      user = User.find_by(email: "admin@admin.com")
      expect(user.token).to be_nil
    end

    it_behaves_like 'require user be signed out' do
      let(:action) { patch :reset_password_submit, new_password: "ad23", token: "123" }
    end
  end


  describe 'GET join' do
    it 'sets the @invitation variable' do
      user = Fabricate(:user)
      i = Fabricate(:invitation, inviter: user)
      i.generate_token; i.save

      get :join, token: i.token
      expect(assigns(:invitation)).to eq i
    end

    it 'sets the @user variable' do
      user = Fabricate(:user)
      i = Fabricate(:invitation, inviter: user)
      i.generate_token; i.save
      
      get :join, token: i.token
      expect(assigns(:user)).to be_new_record
    end

    it 'sets the @token variable' do
      user = Fabricate(:user)
      i = Fabricate(:invitation, inviter: user)
      i.generate_token; i.save
      
      get :join, token: i.token
      expect(assigns(:token)).to be_present
    end

    it 'renders the join template' do
      user = Fabricate(:user)
      i = Fabricate(:invitation, inviter: user)
      i.generate_token; i.save
      
      get :join, token: i.token
      expect(response).to render_template :new
    end

    it 'redirects to expired token path when token not found' do
      get :join, token: 'invalid_token'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe 'POST join_submit' do

    let!(:invitation) { Fabricate(:invitation, inviter: Fabricate(:user)).generate_token }
    let(:post_valid_join_submit) { post :join_submit, token: invitation.token, user: { email: 'friend@test.com', password: 'password', full_name: "Joiner Smith"}, stripeToken: valid_token }
    let(:post_invalid_join_submit) { post :join_submit, token: invitation.token, user: { email: 'friend@test.com' }, stripeToken: valid_token }
    after { ActionMailer::Base.deliveries.clear }

    context 'when token is found' do
      context 'when user input is valid' do
        context 'charge successful' do

          before do
            charge = double('charge', successful?: true)
            StripeWrapper::Charge.stub(:create).and_return(charge)
            post_valid_join_submit
          end

          it 'creates new user' do
            expect(assigns(:user).persisted?).to be_truthy
          end

          it 'set user to follow inviter' do
            expect(assigns(:user).follow_users.include?(invitation.inviter)).to be_truthy
          end

          it 'set inviter to follow user' do          
            expect(invitation.inviter.follow_users.include?(assigns(:user))).to be_truthy
          end
        end

        context 'charge is unsuccessful' do

          before do
            charge = double('charge', successful?: false, error_message: "Card is rejected")
            StripeWrapper::Charge.stub(:create).and_return(charge)
            post_valid_join_submit
          end

          it 'does not create a new user' do
            expect(User.all.count).to eq 1    # only the invter exist
          end

          it 'flash error' do
            expect(flash[:error]).to be_present
          end

          it 'renders :new template' do
            expect(response).to render_template :new
          end
        end
      end    

      context 'when user input is invalid' do
        before { post_invalid_join_submit }
      
        it 'flash error if user does not save' do
          expect(flash[:error]).to eq "Please fill up the form correctly"
        end
        
        it 'sets the @user variable' do
          expect(assigns(:user)).to be_new_record
        end
        
        it 'sets @user variable object with previous input' do
          expect(assigns(:user).email).to eq 'friend@test.com'
        end
        
        it 'renders new template if user does not save' do
          expect(response).to render_template :new
        end
        
        it 'does not send email' do
          expect(ActionMailer::Base.deliveries.last).to be_nil
        end

        it 'does not process any charge to the customer' do
          expect(assigns(:user).valid?).to be_falsey
        end
      end
    end

    context 'when token not found' do
      it 'redirects to expired token path' do
        post :join_submit, token: '9999'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end