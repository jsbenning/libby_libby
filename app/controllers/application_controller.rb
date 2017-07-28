class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :create_base_genres



  private 

  
  def create_base_genres
    if Genre.all.empty?
      BASE_GENRES.each do |genre|
        Genre.create!(name: genre)
      end
    end
  end


end
