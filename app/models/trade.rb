class Trade < ApplicationRecord

  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  has_one :initial_book, :class_name => 'Book', :foreign_key => 'initial_book_id'
  has_one :matched_book, :class_name => 'Book', :foreign_key => 'matched_book_id'


#   def self.user_trades(user)
#     Trade.where(:owner_id => user.id OR :requester_id => user.id)
#   end

# end



  def self.user_requested(user)
    Trade.where(:requester_id => user.id, :status => "pending").to_a
  end

  def self.user_received(user)
    Trade.where(:owner_id => user.id, :status => "pending").to_a 
  end

  def self.user_completed(user)
    Trade.where(:owner_id => user.id, :status => "complete").to_a
  end

  def self.completed_by_other(user)
    Trade.where(:requester_id => user.id, :status => "complete").to_a
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
end




  