class Trade < ApplicationRecord

  # belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  # belongs_to :responder, :class_name => 'User', :foreign_key => 'responder_id'
  has_one :requested_book, :class_name => 'Book', :foreign_key => 'requested_book_id'
  has_one :responded_book, :class_name => 'Book', :foreign_key => 'responded_book_id'


  # def self.user_trades(user) # a simplified method to call db only once
  #   Trade.where("owner_id = ? OR requester_id = ?", user.id, user.id)
  # end

  # def self.shared_trade(user1, user2)
  #   Trade.where(:owner_id => user1.id).where(:requester_id => user2.id, :status => "pending").first
  # end

  # def requested_book_owner
  #   User.find(self.requested_book.user)
  # end

  # def responded_book_owner
  #   User.find(self.responded_book.user)
  # end

  # def requested_book
  #   Book.find(self.requested_book_id)
  # end

  # def responded_book
  #   Book.find(self.responded_book_id)
  # end



  def self.user_rating(user)
    ratings = Array.new
    trades = Trade.all.map do |tr|
      if tr.requested_book.user == user && tr.requested_book_owner_rating)
        ratings << tr.requested_book_owner_rating.to_f
      elsif 
        (tr.responded_book.user == user && tr.responded_book_owner_rating)
        ratings << tr.responded_book_owner_rating.to_f
      end 
    if ratings.empty?
      rating = user.rating
    else
      rating = (ratings.inject(0.0){|sum, x| sum + x})/ratings.length).round
    end
    rating
  end


           


  