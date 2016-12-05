class User < ApplicationRecord
  ROLES = %i[admin reader]
  has_many :books, inverse_of: :user
  accepts_nested_attributes_for :books

  has_many :trades

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def first_name
    if self.real_name
      x = self.real_name.split(" ")[0].capitalize
    end
    first_name =  x ||= self.email
    first_name
  end

  def user_rating
    my_owner_ratings = Trade.where(:owner_id => self.id).where.not(:initial_book_owner_rating => nil)
    my_trader_ratings = Trade.where(:requester_id => self.id).where.not(:matched_book_owner_rating => nil)

    my_ratings = my_owner_ratings + my_trader_ratings

    if my_ratings.empty? 
      @rating = "You don't have enough ratings to evaluate"

      ###### Continue tomorrow
    else
      array1 = my_ratings.map{ |el| el.initial_book_owner_rating.to_i }
      array2 = my_ratings.map{ |el| el.matched_book_owner_rating.to_i }

      num1 = array1.inject(0.0){ |sum, el| sum + el }.to_f / array1.size
      num2 = array2.inject(0.0){ |sum, el| sum + el }.to_f / array2.size

      @rating = ((num1 + num2) / 2)
    end
    @rating
  end

  def admin?
    self.role == "admin"
  end
           
end
