module Tokenable
  extend ActiveSupport::Concern

  def generate_token
    self.token = SecureRandom.urlsafe_base64
    self.save(validate: false)
    self
  end

  def clear_token
    self.token = nil
    save(validate: false)
    self
  end
end