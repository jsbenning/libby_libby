class GenreSerializer < ActiveModel::Serializer
  attributes :id, :first_trader_id, :second_trader_id, :book_first_trader_wants_id, :book_second_trader_wants_id, :status, :first_trader_rating, :second_trader_rating, :created_at, :updated_at


end