class RemoveOwnerIdFromTrades < ActiveRecord::Migration[5.0]
  def change
    remove_column :trades, :owner_id, :integer
  end
end
