class Trade < ApplicationRecord


  belongs_to :trader_one, :class_name => 'User', :foreign_key => 'trader_one_id'
  belongs_to :trader_two, :class_name => 'User', :foreign_key => 'trader_two_id'
  has_one :book_trader_one_wants, :class_name => 'Book', :foreign_key => 'book_trader_one_wants_id'
  has_one :book_trader_two_wants, :class_name => 'Book', :foreign_key => 'book_trader_two_wants_id'


  # def self.user_trades(user) # a simplified method to call db only once
  #   Trade.where("trader_two_id = ? OR trader_one_id = ?", user.id, user.id)
  # end

  # def self.shared_trade(user1, user2)
  #   Trade.where(:owner_id => user1.id).where(:trader_one_id => user2.id, :status => "pending").first
  # end

  # def book_trader_one_wants_owner
  #   User.find(self.book_trader_one_wants.user)
  # end

  # def book_trader_two_wants_owner
  #   User.find(self.book_trader_two_wants.user)
  # end

  # def book_trader_one_wants
  #   Book.find(self.book_trader_one_wants_id)
  # end

  # def book_trader_two_wants
  #   Book.find(self.book_trader_two_wants_id)
  # end



  def self.user_rating(user)
    ratings = Array.new
    trades = Trade.all.map do |tr|
      if tr.book_trader_one_wants.user == user && tr.book_trader_one_wants_owner_rating)
        ratings << tr.book_trader_one_wants_owner_rating.to_f
      elsif 
        (tr.book_trader_two_wants.user == user && tr.book_trader_two_wants_owner_rating)
        ratings << tr.book_trader_two_wants_owner_rating.to_f
      end 
    if ratings.empty?
      rating = 4
    else
      rating = (ratings.inject(0.0){|sum, x| sum + x})/ratings.length.round
    end
    rating
  end


           


  