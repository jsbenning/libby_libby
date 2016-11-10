class CreateReviewsUsers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :reviews, :users do |t|
      t.index :reviewer_id
      t.index :reviewee_id
    end
  end
end
