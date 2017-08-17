class RemoveTradeIdFromBooks < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :trade_id, :integer
  end
end
