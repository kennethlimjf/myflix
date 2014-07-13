require 'spec_helper'

# Here we will test real implementation of Mailer as well. Hence, Mailer wil not be stubbed/mocked.
# However, StriperWrapper::Charge will be stubbed here.
describe UserRegistration do

  before do
    charge = double('charge', successful?: true, error_message: nil)
    StripeWrapper::Charge.stub(:create).and_return(charge)
  end
  after { ActionMailer::Base.deliveries.clear }
  let(:user) { Fabricate.build(:user) }

  it 'process payment when user is valid' do
    StripeWrapper::Charge.should_receive(:create)
    ur = UserRegistration.new(user, 1)
    ur.process
  end

  it 'does not process payment when user is invalid' do
    user.email = nil
    StripeWrapper::Charge.should_not_receive(:create)
    ur = UserRegistration.new(user, 1)
    ur.process
  end

  it 'show error_message when user is invalid' do
    user.email = nil
    ur = UserRegistration.new(user, 1)
    ur.process
    expect(ur.error_message).to eq "Please fill up user form correctly"
  end

  it 'register user when charge is successful' do
    StripeWrapper::Charge.should_receive(:create)
    UserRegistration.any_instance.should_receive(:register_user)
    ur = UserRegistration.new(user, 1)
    ur.process
  end

  it 'show error_message when charge is unsuccessful' do
    charge = double('charge', successful?: false, error_message: "Card is rejected")
    StripeWrapper::Charge.stub(:create).and_return(charge)
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