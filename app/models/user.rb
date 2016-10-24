class User < ApplicationRecord
  has_many :books, inverse_of: :user
  # has_many :bookgenres, through: :books (not sure about this)
  accepts_nested_attributes_for :books
  
  has_many :requests, :class_name => 'Trade', :foreign_key => 'requester_id'
  has_many :trades, :class_name => 'Trade', :foreign_key => 'owner_id'

  has_many :sent_messages, :class_name => 'Message', :foreign_key => 'sender_id'
  has_many :received_messages, :class_name => 'Message', :foreign_key => 'recipient_id'

  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
