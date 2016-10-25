class Book < ApplicationRecord
  belongs_to :user, inverse_of: :books
  validates_presence_of :user
  has_many :book_genres
  has_many :genres, through: :book_genres


  def genres_attributes=(genre_attributes)
    genre_attributes.values.each do |genre_attribute|
      genre = Genre.find_or_create_by(genre_attribute)
      self.genres << genre
    end
  end
  
end
