class User < ApplicationRecord
  before_save :capitalize_fields
  # before_save :get_state
  # before_save :state_not_nil
  validates :real_name, :street, :city, :state, :zipcode, presence: true, on: :update # can create but not update incomplete user model
  validates :state, inclusion: { in: ["AK","Alaska", "AL","Alabama", "AR","Arkansas", "AS","American Samoa", "AZ","Arizona", "CA",\
    "California","CO","Colorado", "CT","Connecticut","DC","District of Columbia", "DE","Delaware", "FL","Florida", "GA","Georgia",\
    "GU","Guam", "HI","Hawaii","IA","Iowa", "ID","Idaho", "IL","Illinois", "IN","Indiana","KS","Kansas", 
                "KY","Kentucky", 
                "LA","Louisiana", 
                "MA","Massachusetts", 
                "MD","Maryland", 
                "ME","Maine", 
                "MI","Michigan", 
                "MN","Minnesota", 
                "MO","Missouri", 
                "MS","Mississippi", 
                "MT","Montana", 
                "NC","North Carolina", 
                "ND","North Dakota", 
                "NE","Nebraska", 
                "NH","New Hampshire", 
                "NJ","New Jersey", 
                "NM","New Mexico", 
                "NV","Nevada", 
                "NY","New York", 
                "OH","Ohio", 
                "OK","Oklahoma", 
                "OR","Oregon", 
                "PA","Pennsylvania", 
                "PR","Puerto Rico", 
                "RI","Rhode Island", 
                "SC","South Carolina", 
                "SD","South Dakota", 
                "TN","Tennessee", 
                "TX","Texas", 
                "UT","Utah", 
                "VA","Virginia", 
                "VI","Virgin Islands", 
                "VT","Vermont", 
                "WA","Washington", 
                "WI","Wisconsin", 
                "WV","West Virginia", 
                "WY","Wyoming"], message: "%{value} is not a valid state" }


  
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

  def capitalize_fields
    self.real_name.split(" ").each{|w| w.capitalize!()}.join(" ")
    self.street.split(" ").each{|w| w.capitalize!()}.join(" ")
    self.city.split(" ").each{|w| w.capitalize!()}.join(" ")
    if self.state.length == 2
      self.state.upcase!
    elsif self.state.length > 2
      self.state.split(" ").each{|w| w.capitalize!()}.join(" ")
    end        
  end

  # def get_state
  #   my_state = ""
  #   states = [ "AK","Alaska", 
  #               "AL","Alabama", 
  #               "AR","Arkansas", 
  #               "AS","American Samoa", 
  #               "AZ","Arizona", 
  #               "CA","California", 
  #               "CO","Colorado", 
  #               "CT","Connecticut", 
  #               "DC","District of Columbia", 
  #               "DE","Delaware", 
  #               "FL","Florida", 
  #               "GA","Georgia", 
  #               "GU","Guam", 
  #               "HI","Hawaii", 
  #               "IA","Iowa", 
  #               "ID","Idaho", 
  #               "IL","Illinois", 
  #               "IN","Indiana", 
  #               "KS","Kansas", 
  #               "KY","Kentucky", 
  #               "LA","Louisiana", 
  #               "MA","Massachusetts", 
  #               "MD","Maryland", 
  #               "ME","Maine", 
  #               "MI","Michigan", 
  #               "MN","Minnesota", 
  #               "MO","Missouri", 
  #               "MS","Mississippi", 
  #               "MT","Montana", 
  #               "NC","North Carolina", 
  #               "ND","North Dakota", 
  #               "NE","Nebraska", 
  #               "NH","New Hampshire", 
  #               "NJ","New Jersey", 
  #               "NM","New Mexico", 
  #               "NV","Nevada", 
  #               "NY","New York", 
  #               "OH","Ohio", 
  #               "OK","Oklahoma", 
  #               "OR","Oregon", 
  #               "PA","Pennsylvania", 
  #               "PR","Puerto Rico", 
  #               "RI","Rhode Island", 
  #               "SC","South Carolina", 
  #               "SD","South Dakota", 
  #               "TN","Tennessee", 
  #               "TX","Texas", 
  #               "UT","Utah", 
  #               "VA","Virginia", 
  #               "VI","Virgin Islands", 
  #               "VT","Vermont", 
  #               "WA","Washington", 
  #               "WI","Wisconsin", 
  #               "WV","West Virginia", 
  #               "WY","Wyoming"]
  #   if self.state.nil? || self.state.length <= 1
  #     my_state = nil
  #   elsif self.state.length == 2
  #     my_stateupcase!
  #   else
  #     my_state = my_state.split(" ").each{|w| w.capitalize!()}.join(" ")
  #   end
  #   if states.include?(my_state)
  #     self.state = my_state
  #   else
  #     my_state = nil  
  #   end
  #   self.state = my_state
  # end

  # def state_not_nil
  #   if self.state.nil?
  #     errors.add :state, 'cannot be nil, must be legitimate US state'
  #   end
  # end


        

  def rating
    Trade.user_rating(self)
  end          
end


