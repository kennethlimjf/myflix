require 'spec_helper'

describe StripeWrapper, :vcr do

  before { Stripe.api_key = Rails.configuration.stripe[:secret_key] }
  let(:valid_token) { Stripe::Token.create( :card => { :number => card_number, :exp_month => 7, :exp_year => 2020, :cvc => "123" } ).id }
  let(:invalid_token) { Stripe::Token.create( :card => { :number => invalid_card_number, :exp_month => 7, :exp_year => 2020, :cvc => "123" } ).id }
  let(:card_number) { "4242424242424242" }
  let(:invalid_card_number) { "4000000000000002" }

  describe 'Charge' do  
    context 'when input is valid' do
      it 'response status should be successful' do
        response = StripeWrapper::Charge.create(amount: 999, card: valid_token)
        expect(response).to be_successful
      end

      it 'have no error message' do
        response = StripeWrapper::Charge.create(amount: 999, card: valid_token)
        expect(response.error_message).to be_nil
      end
    end

    context 'when input in invalid' do
      it 'error_message is present' do
        response = StripeWrapper::Charge.create(amount: 999, card: invalid_token)
        expect(response.error_message).to be_present
      end

      it 'successful to be false' do
        response = StripeWrapper::Charge.create(amount: 999, card: invalid_token)
        expect(response.successful?).to be_falsey
      end
    end
  end

  describe 'Subscribe' do
    context 'when credit card is valid' do
      it 'returns status successful' do
        card, plan, email = valid_token, 'regular', 'test@test.com'
        response = StripeWrapper::Subscribe.create(card: card, plan: plan, email: email)
        expect(response).to be_successful
      end
      it 'has no error message' do
        card, plan, email = valid_token, 'regular', 'test@test.com'
        response = StripeWrapper::Subscribe.create(card: card, plan: plan, email: email)
        expect(response.error_message).to be_nil
      end
      it 'response should have a stripe customer id' do
        card, plan, email = valid_token, 'regular', 'test@test.com'
        response = StripeWrapper::Subscribe.create(card: card, plan: plan, email: email)
        expect(response.stripe_customer_id).to be_present
      end
    end

    context 'when credit card is invalid' do
      it 'returns an error message' do
        card, plan, email = invalid_token, 'regular', 'test@test.com'
        response = StripeWrapper::Subscribe.create(card: card, plan: plan, email: email)
        expect(response.error_message).to be_present
      end
      it 'successful? returns false' do
        card, plan, email = invalid_token, 'regular', 'test@test.com'
        response = StripeWrapper::Subscribe.create(card: card, plan: plan, email: email)
        expect(response.successful?).to be_falsey
      end
      it '@response should be a Stripe:CardError class' do
        card, plan, email = invalid_token, 'regular', 'test@test.com'
        response = StripeWrapper::Subscribe.create(card: card, plan: plan, email: email)
        expect(response.response.class).to eq Stripe::CardError
      end
    end
  end

end