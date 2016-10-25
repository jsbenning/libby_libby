class Trade < ApplicationRecord
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  has_one :initial_book, :class_name => 'Book', :foreign_key => 'initial_book_id'
  has_one :matched_book, :class_name => 'Book', :foreign_key => 'matched_book_id'

  def self.trades_requested(user)
    coll = Array.new
    Trade.each do |trade|
      if trade.owner_id == user.id
        coll << trade
      end
    end
    coll
  end

  def self.trades_received(user)
    coll = Array.new
    Trade.each do |trade|
      if trade.requester_id == user.id
        coll << trade
      end
    end
    coll
  end

end
