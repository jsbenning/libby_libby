class AddRequestIdToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :request_id, :integer
  end
end
