require 'spec_helper'

describe "Stripe events" do

  describe "Create a payment on successful charge", :vcr do    
    let(:successful_charge_data) do
      {
        "id" => "evt_14MEuN4ScHo4kCbcc92QG9LP",
        "created" => 1406795251,
        "livemode" => false,
        "type" => "charge.succeeded",
        "data" => {
          "object" => {
            "id" => "ch_14MEuN4ScHo4kCbcDZif0uGA",
            "object" => "charge",
            "created" => 1406795251,
            "livemode" => false,
            "paid" => true,
            "amount" => 2000,
            "currency" => "usd",
            "refunded" => false,
            "card" => {
              "id" => "card_14MEuM4ScHo4kCbcnyaQC18B",
              "object" => "card",
              "last4" => "4242",
              "brand" => "Visa",
              "funding" => "credit",
              "exp_month" => 7,
              "exp_year" => 2015,
              "fingerprint" => "Bs16CEwyEEcJyayY",
              "country" => "US",
              "name" => nil,
              "address_line1" => nil,
              "address_line2" => nil,
              "address_city" => nil,
              "address_state" => nil,
              "address_zip" => nil,
              "address_country" => nil,
              "cvc_check" => "pass",
              "address_line1_check" => nil,
              "address_zip_check" => nil,
              "customer" => "cus_4VFPZkwHhhAU0o"
            },
            "captured" => true,
            "refunds" => {
              "object" => "list",
              "total_count" => 0,
              "has_more" => false,
              "url" => "/v1/charges/ch_14MEuN4ScHo4kCbcDZif0uGA/refunds",
              "data" => [
              ]
            },
            "balance_transaction" => "txn_14MEuN4ScHo4kCbc0yb6gS4J",
            "failure_message" => nil,
            "failure_code" => nil,
            "amount_refunded" => 0,
            "customer" => "cus_4VFPZkwHhhAU0o",
            "invoice" => "in_14MEuN4ScHo4kCbc0aOFhRUp",
            "description" => nil,
            "dispute" => nil,
            "metadata" => {
            },
            "statement_description" => nil,
            "receipt_email" => nil
          }
        },
        "object" => "event",
        "pending_webhooks" => 1,
        "request" => "iar_4VFPUnASWamtP8"
      }
    end

    it 'creates a Payment record' do
      post '/stripe-events', successful_charge_data
      expect(Payment.count).to eq 1
    end

    it 'creates a Payment record with amount' do
      post '/stripe-events', successful_charge_data
      expect(Payment.first.amount).to eq 2000
    end

    it 'creates a Payment record with user' do
      Fabricate(:user, stripe_customer_id: 'cus_4VFPZkwHhhAU0o')
      post '/stripe-events', successful_charge_data
      expect(Payment.first.user).to be_present
    end

    it 'creates a Payment record with reference id' do
      post '/stripe-events', successful_charge_data
      expect(Payment.first.reference_id).to eq 'ch_14MEuN4ScHo4kCbcDZif0uGA'
    end
  end

  describe 'Disable an account on charge failed', :vcr do

    let(:failed_charge_data) do
      {
        "id" => "evt_14MEuN4ScHo4kCbcc92QG9LP",
        "created" => 1406795251,
        "livemode" => false,
        "type" => "charge.failed",
        "data" => {
          "object" => {
            "id" => "ch_14MEuN4ScHo4kCbcDZif0uGA",
            "object" => "charge",
            "created" => 1406795251,
            "livemode" => false,
            "paid" => false,
            "amount" => 2000,
            "currency" => "usd",
            "refunded" => false,
            "card" => {
              "id" => "card_14MEuM4ScHo4kCbcnyaQC18B",
              "object" => "card",
              "last4" => "4242",
              "brand" => "Visa",
              "funding" => "credit",
              "exp_month" => 7,
              "exp_year" => 2015,
              "fingerprint" => "Bs16CEwyEEcJyayY",
              "country" => "US",
              "name" => nil,
              "address_line1" => nil,
              "address_line2" => nil,
              "address_city" => nil,
              "address_state" => nil,
              "address_zip" => nil,
              "address_country" => nil,
              "cvc_check" => "pass",
              "address_line1_check" => nil,
              "address_zip_check" => nil,
              "customer" => "cus_4VFPZkwHhhAU0o"
            },
            "captured" => true,
            "refunds" => {
              "object" => "list",
              "total_count" => 0,
              "has_more" => false,
              "url" => "/v1/charges/ch_14MEuN4ScHo4kCbcDZif0uGA/refunds",
              "data" => [
              ]
            },
            "balance_transaction" => "txn_14MEuN4ScHo4kCbc0yb6gS4J",
            "failure_message" => nil,
            "failure_code" => nil,
            "amount_refunded" => 0,
            "customer" => "cus_4VFPZkwHhhAU0o",
            "invoice" => "in_14MEuN4ScHo4kCbc0aOFhRUp",
            "description" => nil,
            "dispute" => nil,
            "metadata" => {
            },
            "statement_description" => nil,
            "receipt_email" => nil
          }
        },
        "object" => "event",
        "pending_webhooks" => 1,
        "request" => "iar_4VFPUnASWamtP8"
      }
    end

    it 'sets user status to false' do
      Fabricate(:user, stripe_customer_id: 'cus_4VFPZkwHhhAU0o')
      post '/stripe-events', failed_charge_data
      expect(User.first.status).to be_falsey
    end

    it 'sends an email' do
      Fabricate(:user, stripe_customer_id: 'cus_4VFPZkwHhhAU0o')
      post '/stripe-events', failed_charge_data
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end
  end
end