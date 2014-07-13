require 'spec_helper'

describe ForgotPassword do
  it 'successful returns true after process if user is valid' do
    controller = double('controller', url_for: 'http://example.com/forgot-password/12345', host_with_port: 'host:port')
    controller.stub(request: controller)
    controller.should_receive(:url_for)
    user = double('user', generate_token: nil, reload: nil, token: '')
    UserMailer.should_receive(:delay).and_return(UserMailer)
    UserMailer.stub(forgot_password: true)

    forgot_password = ForgotPassword.new(user, controller)
    forgot_password.process
    expect(forgot_password.successful?).to be_truthy
  end
end