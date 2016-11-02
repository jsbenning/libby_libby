class Trade < ApplicationRecord

  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  has_one :initial_book, :class_name => 'Book', :foreign_key => 'initial_book_id'
  has_one :matched_book, :class_name => 'Book', :foreign_key => 'matched_book_id'

  def self.requested_trades(user)
    Trade.where(:requester_id => user.id, :matched_book_id => nil).to_a
  end

  def self.accepted_trades(user)
    Trade.where(:owner_id => user.id, :matched_book_id => nil).to_a 
  end

  def self.my_completed_requested_trades(user)
    Trade.where(:requester_id => user.id).where.not(matched_book_id: nil).to_a
  end

  def self.my_completed_accepted_trades(user)
    Trade.where(:owner_id => user.id).where.not(matched_book_id: nil).to_a
  end

  def complete?
    return true if self.requester_id && self.owner_id && self.matched_book_id && self.initial_book_id 
  end
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





  