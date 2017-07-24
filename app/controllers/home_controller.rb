class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @books = Book.latest_titles
  end
  
end
