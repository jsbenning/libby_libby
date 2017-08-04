class Book < ApplicationRecord
  before_save :capitalize_fields
  validates :title, :condition, presence: true

  #scope :visible, -> { where(status: 'at_home')} #forgot how this works ---zbytecny?
  scope :by_date, -> { order('created_at DESC, id DESC') }
  
  belongs_to :user, dependent: :destroy
  validates_presence_of :user
  has_and_belongs_to_many :genres 
  accepts_nested_attributes_for :genres
  

  def genres_attributes=(genre_attributes)
    genre_attributes.values.each do |genre_attribute|
      genre = Genre.find_or_create_by(genre_attribute)
      self.genres << genre
    end
  end
  
  def capitalize_fields
    self.title.capitalize!
    self.author_first_name.capitalize!
    self.author_last_name.capitalize!
    self.description.capitalize!
  end

  def self.search(search, user) #checks if book 'at_home', and that it isn't the searcher's title
    wildcard_search = "%#{search}%"
    if wildcard_search
      Book.where(:status => 'at_home').where.not(:user_id => user.id).where("title LIKE ? OR isbn LIKE ? OR author_last_name LIKE ?", wildcard_search, wildcard_search, wildcard_search)
    else
      Book.where(:status => 'at_home').where.not(:user_id => user.id)
    end
  end
  
end

