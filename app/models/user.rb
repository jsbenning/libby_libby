class User < ApplicationRecord
  has_many :books, inverse_of: :user
  accepts_nested_attributes_for :books

  has_many :trades
  has_many :reviews, :through => :trades

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]


  def present_user_rating
    user_review_array = self.reviews.map{ |review| review.rating }
    if user_review_array.count > 0
      present_user_rating = user_review_array.inject(0){|sum, x| sum + x}.to_f / x.count
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
           
end
