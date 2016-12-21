class User < ApplicationRecord
  enum role: [ :reader, :mod, :admin ]# admins can delete all users, mods can view all users
  has_many :books, inverse_of: :user
  accepts_nested_attributes_for :books
  has_many :genres, through: :books

  has_many :trades

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def first_name #refactor
    if self.real_name
      x = self.real_name.split(" ")[0].capitalize
    end
    first_name =  x ||= self.email
    first_name
  end

  def self.mid_clearance(user)
    user.admin? || user.mod?
  end
  

  def user_rating
    this_owner_ratings = Trade.where(:owner_id => self.id).where.not(:initial_book_owner_rating => nil)
    this_trader_ratings = Trade.where(:requester_id => self.id).where.not(:matched_book_owner_rating => nil)

    this_ratings = this_owner_ratings + this_trader_ratings

    if this_ratings.empty? 
      @rating = "User doesn't have enough ratings to evaluate"

    else
      array1 = this_ratings.map{ |el| el.initial_book_owner_rating.to_i }
      array2 = this_ratings.map{ |el| el.matched_book_owner_rating.to_i }

      num1 = array1.inject(0.0){ |sum, el| sum + el }.to_f / array1.size
      num2 = array2.inject(0.0){ |sum, el| sum + el }.to_f / array2.size

      @rating = ((num1 + num2) / 2)
    end
    @rating
  end

           
end
