class Payment < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :amount
  validates_presence_of :reference_id
end