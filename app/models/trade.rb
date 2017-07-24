class Trade < ApplicationRecord

  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  has_one :initial_book, :class_name => 'Book', :foreign_key => 'initial_book_id'
  has_one :matched_book, :class_name => 'Book', :foreign_key => 'matched_book_id'


  def self.user_trades(user) # a simplified method to call db only once
    Trade.where("owner_id = ? OR requester_id = ?", user.id, user.id)
  end

  def self.shared_trade(user1, user2)
    Trade.where(:owner_id => user1.id).where(:requester_id => user2.id, :status => "pending").first
  end

  def owner
    User.find(self.owner_id)
  end

  def requester
    User.find(self.requester_id)
  end

  def initial_book
    Book.find(self.initial_book_id)
  end

  def matched_book
    Book.find(self.matched_book_id)
  end

  def self.user_rating(user)
    ratings = Array.new
    trades = Trade.where("owner_id = ? OR requester_id = ?", user.id, user.id)
    trades.each do |trade|
      if trade.owner_id == user.id && !(trade.initial_book_owner_rating.nil?)
        ratings << initial_book_owner_rating.to_f
      elsif trade.requester_id == user.id && !(trade.matched_book_owner_rating.nil?)
        ratings << matched_book_owner_rating.to_f
      end
    end
    if ratings.empty?
      @rating = "There are not enough ratings to evaluate this user"
    else
      @rating = (ratings.inject(0.0){|sum, x| sum + x})/ratings.length
      @rating = @rating.round
    end
    @rating
  end    
end



  