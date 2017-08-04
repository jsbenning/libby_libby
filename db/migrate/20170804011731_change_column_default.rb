class ChangeColumnDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default :trades, :first_trader_rating, nil
    change_column_default :trades, :second_trader_rating, nil
  end
end
