require 'spec_helper'

# Here we will test real implementation of Mailer as well. Hence, Mailer wil not be stubbed/mocked.
# However, StriperWrapper::Charge will be stubbed here.
describe UserRegistration do

  before do
    subscription = double('subscription', stripe_customer_id: 1, successful?: true)
    StripeWrapper::Subscribe.stub(:create).and_return(subscription)
  end
  after { ActionMailer::Base.deliveries.clear }
  let(:user) { Fabricate.build(:user) }

  it 'subscribe when user is valid' do
    StripeWrapper::Subscribe.should_receive(:create)
    ur = UserRegistration.new(user, 1)
    ur.process
  end

  it 'does not subscribe when user is invalid' do
    user.email = nil
    StripeWrapper::Subscribe.should_not_receive(:create)
    ur = UserRegistration.new(user, 1)
    ur.process
  end

  it 'show error_message when user is invalid' do
    user.email = nil
    ur = UserRegistration.new(user, 1)
    ur.process
    expect(ur.error_message).to eq "Please fill up user form correctly"
  end

  it 'sets the user stripe customer id' do
    ur = UserRegistration.new(user, 1)
    ur.process
    expect(ur.user.stripe_customer_id).to be_present
  end

  it 'sets the user status to true' do
    ur = UserRegistration.new(user, 1)
    ur.process
    expect(ur.user.status).to be_truthy
  end

  it 'register user when subscription is successful' do
    StripeWrapper::Subscribe.should_receive(:create)
    UserRegistration.any_instance.should_receive(:register_user)
    ur = UserRegistration.new(user, 1)
    ur.process
  end

  it 'show error_message when subscription is unsuccessful' do
    subscription = double('subscription', successful?: false, error_message: "Card is rejected")
    StripeWrapper::Subscribe.stub(:create).and_return(subscription)
    ur = UserRegistration.new(user, 1)
    ur.process
    expect(ur.error_message).to eq "Card is rejected"
  end

  it 'successful? returns true when register user is complete' do
    ur = UserRegistration.new(user, 1)
    ur.process
    expect(ur.successful?).to eq true
  end

  it 'send out mail when register user is complete' do
    ur = UserRegistration.new(user, 1)
    ur.process
    expect(ActionMailer::Base.deliveries.count).to eq 1
  end

  it 'send out mail to the user email' do
    ur = UserRegistration.new(user, 1)
    ur.process
    expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
  end
end