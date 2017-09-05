class BookSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :author_last_name, :author_first_name, :isbn, :condition, :description, :status, :genres
  belongs_to :user
  belongs_to :trade, class_name: 'Trade', foreign_key: 'request_id', optional: true
  belongs_to :trade, class_name: 'Trade', foreign_key: 'response_id', optional: true

  has_many :genres

  # def genres
  #   object.genres.map do |genre|
  #     GenreSerializer.new(genre).attributes
  #   end
  # end

end

