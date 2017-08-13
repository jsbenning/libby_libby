class AddTradeIdToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :trade_id, :integer
  end
end
