class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :trades, :trader_one_id, :first_trader_id
    rename_column :trades, :trader_two_id, :second_trader_id
    rename_column :trades, :book_trader_one_wants_id, :book_first_trader_wants_id
    rename_column :trades, :book_trader_two_wants_id,  :book_second_trader_wants_id
    rename_column :trades, :trader_one_rating, :first_trader_rating
    rename_column :trades, :trader_two_rating, :second_trader_rating
  end 
end
