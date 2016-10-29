class User < ApplicationRecord
  has_many :books, inverse_of: :user
  # has_many :bookgenres, through: :books (not sure about this)
  accepts_nested_attributes_for :books
  has_many :reviews
  
  has_many :requests, :class_name => 'Trade', :foreign_key => 'requester_id'
  has_many :trades, :class_name => 'Trade', :foreign_key => 'owner_id'

  has_many :sent_messages, :class_name => 'Message', :foreign_key => 'sender_id'
  has_many :received_messages, :class_name => 'Message', :foreign_key => 'recipient_id'

  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def user_rating
    x = Array.new
    self.reviews.each do |review|
      x << review.rating
    end
    user_rating = x.inject(0){|sum, x| sum + x} / x.count
  end
           
end
