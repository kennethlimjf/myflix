require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter).class_name('User') }
  it { should validate_presence_of(:inviter) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:message) }

  describe '#generate_token' do
    it 'generates token for user' do
      invitation = Fabricate.build(:invitation)
      invitation.generate_token
      expect(invitation.token).to be_present
    end
  end
end