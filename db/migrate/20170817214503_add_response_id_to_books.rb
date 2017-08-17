class AddResponseIdToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :response_id, :integer
  end
end
