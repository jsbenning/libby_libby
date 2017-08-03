class Trade < ApplicationRecord


  belongs_to :first_trader, :class_name => 'User', :foreign_key => 'first_trader_id'
  belongs_to :second_trader, :class_name => 'User', :foreign_key => 'second_trader_id'
  has_one :book_first_trader_wants, :class_name => 'Book', :foreign_key => 'book_first_trader_wants_id'
  has_one :book_second_trader_wants, :class_name => 'Book', :foreign_key => 'book_second_trader_wants_id'


  def self.my_trades(user) # a simplified method to call db only once
    Trade.where("second_trader_id = ? OR first_trader_id = ?", user.id, user.id)
  end

  def self.shared_trade(user1, user2) # if Trade.shared_trade
    Trade.where(:second_trader_id => user1.id).where(:first_trader_id => user2.id, :status => "new").first
  end


  # def first_trader      #Are the following four methods auto-generated from AR associations?
  #   User.find(first_trader_id)
  # end

  # def second_trader
  #   User.find(second_trader_id)
  # end

  # def book_first_trader_wants
  #   Book.find(book_first_trader_wants_id)
  # end

  # def book_second_trader_wants
  #   Book.find(book_second_trader_wants_id)
  # end


  def self.user_rating(user)
    ratings = Array.new
    trades = Trade.all.map do |tr|
      if (tr.book_first_trader_wants.user == user && tr.second_trader_rating)
        ratings << tr.second_trader_rating.to_f
      elsif (tr.book_second_trader_wants.user == user && tr.first_trader_rating)
        ratings << tr.first_trader_rating.to_f
      end 
    end
    if ratings.empty?
      rating = 3
    else
      rating = (ratings.inject(0.0){|sum, x| sum + x})/ratings.length.round
    end
    rating
  end


end
           


  