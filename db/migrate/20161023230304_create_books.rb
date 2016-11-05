class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.integer :user_id
      t.string :title
      t.string :author_last_name
      t.string :author_first_name
      t.string :isbn
      t.string :condition
      t.text :description
      t.string :status, default: "at_home" # also "traded"
      t.string :tracking_number

      t.timestamps
    end
  end
end
