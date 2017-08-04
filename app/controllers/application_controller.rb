class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :create_base_genres


  BASE_GENRES = ["History", "Math and Science", "Fiction", "Foreign Language", "Children's", "Young Adult", "Sci-Fi/Fantasy", "Reference", "Social Science", "Art, Design and Fashion", "Psychology and Self-Help", "Horror", "Romance", "Music", "Biography and Memoir", "Travel", "Ethnic Studies", "Nature and the Environment", "Gender Studies", "Legal Studies", "Sports, Crafts and Hobbies", "Health and Medicine", "TV, Media and Film" ]


  private 


  def create_base_genres
    if Genre.all.empty?
      BASE_GENRES.each do |genre|
        Genre.create!(name: genre)
      end
    end
  end

end
