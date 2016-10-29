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
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]


  def user_rating
    x = Array.new
    self.reviews.each do |review|
      x << review.rating
    end
    user_rating = x.inject(0){|sum, x| sum + x} / x.count
  end

  def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
  end

  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  #       user.email = data["email"] if user.email.blank?
  #     end
  #   end
  # end
           
end
