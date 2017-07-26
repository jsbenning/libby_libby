class BookSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :author_last_name, :author_first_name, :isbn, :condition, :description, :status
  #has_and_belongs_to_many :genres
  belongs_to :user

end

