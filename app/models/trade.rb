class Trade < ApplicationRecord
  has_one :owner, :class_name => 'User', :foreign_key => 'owner_id'
  has_one :requester, :class_name => 'User', :foreign_key => 'requester_id'
  has_one :initial_book, :class_name => 'Book', :foreign_key => 'initial_book_id'
  has_one :matched_book, :class_name => 'Book', :foreign_key => 'matched_book_id'
 
end
