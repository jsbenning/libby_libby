class User < ApplicationRecord
  validates :real_name, :street, :city, :state, :zipcode, presence: true, on: :update # can create but not update incomplete user model
  validates :state, inclusion: { in: ["AK","Alaska", "AL","Alabama", "AR","Arkansas", "AS","American Samoa", "AZ","Arizona", "CA",\
    "California","CO","Colorado", "CT","Connecticut","DC","District of Columbia", "DE","Delaware", "FL","Florida", "GA","Georgia",\
    "GU","Guam", "HI","Hawaii","IA","Iowa", "ID","Idaho", "IL","Illinois", "IN","Indiana","KS","Kansas", "KY","Kentucky","LA",\
    "Louisiana", "MA","Massachusetts", "MD","Maryland", "ME","Maine", "MI","Michigan", "MN","Minnesota", "MO","Missouri", "MS",\
    "Mississippi", "MT","Montana", "NC","North Carolina", "ND","North Dakota", "NE","Nebraska", "NH","New Hampshire", "NJ", \
    "New Jersey", "NM","New Mexico", "NV","Nevada", "NY","New York", "OH","Ohio", "OK","Oklahoma", "OR","Oregon", "PA","Pennsylvania", \
    "PR","Puerto Rico", "RI","Rhode Island","SC","South Carolina", "SD","South Dakota", "TN","Tennessee", "TX","Texas", "UT","Utah", \
    "VA","Virginia", "VI","Virgin Islands",  "VT","Vermont", "WA","Washington", "WI","Wisconsin", "WV","West Virginia", "WY","Wyoming"],\
     message: "%{value} is not a valid state" }, on: :update

  enum role: [ :reader, :mod, :admin ]# admins can make users invisible, mods can only view all users
  has_many :books, :dependent => :destroy
  accepts_nested_attributes_for :books
  has_many :genres, through: :books

  has_many :trades, foreign_key: "first_trader_id", class_name: "Trade"
  has_many :trades, foreign_key: "second_trader_id", class_name: "Trade"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def first_name
    if self.real_name.nil? #|| self.real_name == ""
      first_name = self.email
    else
      first_name = self.real_name.split(" ")[0].capitalize
    end
    first_name
  end

  def visible?
    self.visible == true
  end

  def incomplete_profile?
    x = false
    self.attributes.first(6).each do |attr|
      if attr[1].nil? || attr[1] == ""
        x = true
      end
    end
    x
  end

  def shipworthy? # Has the user entered all shipping info & has books, of which at least one is at home?
    #y = self.incomplete_profile?
    # self.attributes.first(6).each do |attr|
    #   if attr[1].nil? || attr[1] == ""
    #     x = false
    #   end
    # end
    all_books_traded = self.books.all? {|book| book.status == "traded" }# this method doesn't work
    if (self.books.empty? || all_books_traded || self.incomplete_profile?)
      false
    else
      true
    end
  end

  def mod_or_admin?
    self.admin? || self.mod?
  end

  def real_name=(s)
    write_attribute(:real_name, s.to_s.titleize)
  end

  def street=(s)
    write_attribute(:street, s.to_s.titleize)
  end

  def city=(s)
    write_attribute(:city, s.to_s.titleize)
  end

  def state=(s)
    if s.length == 2
      write_attribute(:state, s.to_s.upcase)
    else
      write_attribute(:state, s.to_s.titleize)
    end
  end

  def rating
    user_rating = Trade.user_rating(self)
    case user_rating
    when 2.49...3.1
      "/assets/3stars.png"
    when 1.5...2.49
      "/assets/2stars.png"
    else
      "/assets/1stars.png"
    end
  end

end
