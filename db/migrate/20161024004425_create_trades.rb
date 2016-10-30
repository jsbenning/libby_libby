class CreateTrades < ActiveRecord::Migration[5.0]
  def change
    create_table :trades do |t|
      t.integer :requester_id
      t.integer :initial_book_id
      t.integer :owner_id
      t.integer :matched_book_id
      t.string :status, default: "pending" #or 'complete'

      t.timestamps
    end
  end
end
