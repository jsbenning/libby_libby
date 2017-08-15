class BookSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :author_last_name, :author_first_name, :isbn, :condition, :description, :status, :genres
  #has_many :genres
  belongs_to :user
  #belongs_to :trade

  def genres
    object.genres.map do |genre|
      GenreSerializer.new(genre).attributes
    end
  end

end

