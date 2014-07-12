# This is a wrapper for Stripe API
# For configuration of Stripe API Key, visit the config/initializers/stripe.rb file

module StripeWrapper

  class Charge
    attr_reader :response, :status
    
    def initialize(response, status)
      @response, @status = response, status
    end

    def self.create(options={})
      begin
        charge = Stripe::Charge.create(
          :amount => options[:amount],
          :currency => "usd",
          :card => options[:card],
          :description => options[:description]
        )
        new(charge, :success)
      rescue Stripe::CardError => error
        new(error, :error)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response.message unless successful?
    end
  end

end