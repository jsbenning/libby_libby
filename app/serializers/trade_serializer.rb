class TradeSerializer < ActiveModel::Serializer
  attributes :id, :first_trader_id, :second_trader_id, :book_first_trader_wants_id, :book_second_trader_wants_id, :status, :first_trader_rating, :second_trader_rating, :created_at, :updated_at
  belongs_to :first_trader, :class_name => 'User', :foreign_key => 'first_trader_id'
  belongs_to :second_trader, :class_name => 'User', :foreign_key => 'second_trader_id'
  has_one :book_first_trader_wants, :class_name => 'Book', :foreign_key => 'request_id'
  has_one :book_second_trader_wants, :class_name => 'Book', :foreign_key => 'response_id'

end