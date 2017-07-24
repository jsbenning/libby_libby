class AddOwnerIdToTrades < ActiveRecord::Migration[5.0]
  def change
    add_column :trades, :owner_id, :integer
  end
end
