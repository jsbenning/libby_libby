class Book < ApplicationRecord
  validates :title, presence: true
  
  belongs_to :user, inverse_of: :books
  validates_presence_of :user
  has_and_belongs_to_many :genres
  accepts_nested_attributes_for :genres


  def genres_attributes=(genre_attributes)
    genre_attributes.values.each do |genre_attribute|
      genre = Genre.find_or_create_by(genre_attribute)
      self.genres << genre
    end
  end
  
end
