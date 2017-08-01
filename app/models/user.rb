class User < ApplicationRecord
  validates :real_name, :street, :city, :state, :zipcode, presence: true, on: :update # can create but not update incomplete user model
  
  enum role: [ :reader, :mod, :admin ]# admins can make users invisible, mods can view all users
  has_many :books, :dependent => :destroy
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

  def first_name
    if self.real_name.nil? || self.real_name == ""
      first_name = self.email  
    else
      first_name = self.real_name.split(" ")[0].capitalize 
    end
    first_name 
  end

  def shipworthy? # Has the user entered all shipping info?
    x = true
    self.attributes.first(6).each do |attr|
      if attr[1].nil? || attr[1] == ""
        x = false
      end
    end
    x
  end

  def mod_or_admin?
    self.admin? || self.mod?
  end

  def rating
    Trade.user_rating(self)
  end          
end
