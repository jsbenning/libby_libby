class Message < ApplicationRecord
  has_one :sender, :class_name => 'User', :foreign_key => 'sender_id'
  has_one :recipient, :class_name => 'User', :foreign_key => 'recipient_id'
end
