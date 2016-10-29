class CreateReviewsUsers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :reviews, :users do |t|
      t.index :review_id
      t.index :user_id
    end
  end
end
