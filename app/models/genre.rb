class Genre < ApplicationRecord
  #before_save :confirm_base_genres
  has_and_belongs_to_many :books


  #BASE_GENRES = ["History", "Math and Science", "Fiction", "Foreign Language", "Children's", "Young Adult", "Sci-Fi/Fantasy", "Reference", "Social Science", "Art, Design and Fashion", "Psychology and Self-Help", "Horror", "Romance", "Music", "Biography and Memoir", "Travel", "Ethnic Studies", "Nature and the Environment", "Gender Studies", "Legal Studies", "Sports, Crafts and Hobbies", "Health and Medicine", "TV, Media and Film" ]

  private

  # def self.base_genres
  #   if !(Genre.all.empty?)
  #     Genre.first(BASE_GENRES.length - 1)
  #   else
  #     Genre.all 
  #   end
  # end

  # def self.create_base_genres
  #   if Genre.all.empty?
  #     BASE_GENRES.each do |genre|
  #       Genre.create!(name: genre)
  #     end
  #   end
  # end

  # def confirm_base_genres
  #   self.class.create_base_genres
  # end

end
