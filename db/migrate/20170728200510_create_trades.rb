class CreateTrades < ActiveRecord::Migration[5.0]
  def change
    create_table :trades do |t|
      t.integer :trader_one_id
      t.integer :trader_two_id
      t.integer :book_trader_one_wants_id
      t.integer :book_trader_two_wants_id
      t.string :status, default: "new"
      t.integer :book_trader_one_rating
      t.integer :book_trader_two_rating
    end
  end
end
