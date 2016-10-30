class Trade < ApplicationRecord

  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  has_one :initial_book, :class_name => 'Book', :foreign_key => 'initial_book_id'
  has_one :matched_book, :class_name => 'Book', :foreign_key => 'matched_book_id'

  def self.requested_trades
    Trade.where(requester_id: current_user.id)
  end

  def self.accepted_trades
    @user = current_user
    Trade.where(owner_id: @user.id)
  end

  def self.pending_trades
    pending = Array.new
    Trade.each do |trade|
      if trade.initial_book.user == current_user && matched_book_id == nil
        pending << trade
      end
    end
    pending
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

  def completed?
    return true if self.owner_id && self.requester_id && self.initial_book_id && self.matched_book_id
  end
end


  