Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    amount = event.data.object.amount
    reference_id = event.data.object.id
    user = User.find_by( stripe_customer_id: event.data.object.card.customer )
    payment = Payment.create(user: user, reference_id: reference_id, amount: amount)
  end

  events.subscribe 'charge.failed' do |event|
    user = User.find_by( stripe_customer_id: event.data.object.card.customer )
    user.update_attribute(:status, false)

    begin
      UserMailer.account_deactivated(user).deliver
    rescue Net::SMTPAuthenticationError
      @error_message = "Account deactivated, however there is a problem with sending email."
    end
  end
end