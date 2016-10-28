class Message < ApplicationRecord
  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :recipient, :class_name => 'User', :foreign_key => 'recipient_id'

  def self.messages_sent(user)
    coll = Array.new
    Message.each do |message|
      if trade.sender_id == user.id
        coll << message
      end
    end
    coll
  end

  def self.messages_received(user)
    coll = Array.new
    Messages.each do |message|
      if message.recipient_id == user.id
        coll << message
      end
    end
    coll
  end
end
