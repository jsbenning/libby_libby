class Review < ApplicationRecord
  belongs_to :reviewer, :class_name => 'User', :foreign_key => 'reviewer_id'
  has_one :reviewee, :class_name => 'User', :foreign_key => 'reviewee_id'

end