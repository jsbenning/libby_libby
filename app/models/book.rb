class Book < ApplicationRecord
  validates :title, :condition, presence: true
  scope :by_date, -> { order('created_at DESC, id DESC') }
  
  belongs_to :user, dependent: :destroy
  belongs_to :trade, optional: true
 

  validates_presence_of :user
  has_and_belongs_to_many :genres 
  accepts_nested_attributes_for :genres
  

  def genres_attributes=(genre_attributes)
    genre_attributes.values.each do |genre_attribute|
      genre = Genre.find_or_create_by(genre_attribute)
      self.genres << genre
    end
  end

  def title=(s)
    write_attribute(:title, s.to_s.titleize)
  end

  def author_first_name=(s)
    write_attribute(:author_first_name, s.to_s.titleize)
  end

  def author_last_name=(s)
    write_attribute(:author_last_name, s.to_s.titleize)
  end

  def description=(s)
    write_attribute(:description, s.split(". ").each{|w| w.capitalize!()}.join(". "))
  end

  # def part_of_trade?
  #   if self.trade.first_trader == current_user || self.trade.second_trader== current_user
  #     true
  #   end
  # end


  def self.search(search, user) #checks if book 'at_home', and that it isn't the searcher's title
    wildcard_search = "%#{search}%"
    if wildcard_search
      Book.where(:status => 'at_home').where.not(:user_id => user.id).where("title LIKE ? OR isbn LIKE ? OR author_last_name LIKE ?", wildcard_search, wildcard_search, wildcard_search)
    else
      Book.where(:status => 'at_home').where.not(:user_id => user.id)
    end
  end
  
end

