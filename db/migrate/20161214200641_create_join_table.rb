class CreateJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :books, :genres do |t|
      # t.index [:book_id, :genre_id]
      # t.index [:genre_id, :book_id]
    end
  end
end

# rubyonrails.org example:

    # create_table :assemblies_parts, id: false do |t|
    #   t.belongs_to :assembly, index: true
    #   t.belongs_to :part, index: true
    # end