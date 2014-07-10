class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'
  validates_presence_of :inviter
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :message

  def generate_token
    self.token = SecureRandom.urlsafe_base64
    save(validate: false)
    self
  end
end