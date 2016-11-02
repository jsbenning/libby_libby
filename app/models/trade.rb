class Trade < ApplicationRecord

  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  has_one :initial_book, :class_name => 'Book', :foreign_key => 'initial_book_id'
  has_one :matched_book, :class_name => 'Book', :foreign_key => 'matched_book_id'

  def self.user_needs_response(user)
    Trade.where(:requester_id => user.id).to_a
  end

  def self.user_must_complete(user)
    Trade.where(:owner_id => user.id).to_a 
  end

  def self.user_completed(user)
    Trade.where(:owner_id => user.id, :status => "complete").to_a
  end

  def self.completed_by_other(user)
    Trade.where(:requester_id => user.id, :status => "complete").to_a
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
end




  