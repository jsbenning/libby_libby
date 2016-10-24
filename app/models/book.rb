class Book < ApplicationRecord
  belongs_to :user, inverse_of: :books
  validates_presence_of :user
  has_many :book_genres
  has_many :genres, through: :book_genres
end
