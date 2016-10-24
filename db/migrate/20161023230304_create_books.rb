class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author_last_name
      t.string :author_first_name
      t.string :ISBN
      t.string :condition
      t.string :status, default: "at_home" # also "sent", "received"

      t.timestamps
    end
  end
end
