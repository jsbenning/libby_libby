class HomeController < ApplicationController

  def index
    @books = Book.latest_titles
  end
  
end
