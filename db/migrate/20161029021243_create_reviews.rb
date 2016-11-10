class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :reviewer_id
      t.integer :reviewee_id
      t.integer :rating
      t.string :description
    end
  end
end
