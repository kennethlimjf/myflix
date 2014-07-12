require 'spec_helper'

describe StripeWrapper do

  before { Stripe.api_key = Rails.configuration.stripe[:secret_key] }
  let(:card_number) { "4242424242424242" }
  let(:valid_token) { Stripe::Token.create( :card => { :number => card_number, :exp_month => 7, :exp_year => 2020, :cvc => "123" } ).id }
  let(:invalid_card_number) { "4000000000000002" }
  let(:invalid_token) { Stripe::Token.create( :card => { :number => invalid_card_number, :exp_month => 7, :exp_year => 2020, :cvc => "123" } ).id }
  
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