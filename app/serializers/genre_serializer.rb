class GenreSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_and_belongs_to_many :books
end
