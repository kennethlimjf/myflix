class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :inviter, class_name: 'User'
  validates_presence_of :inviter
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :message
end