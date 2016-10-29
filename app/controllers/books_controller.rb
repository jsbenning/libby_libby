class BooksController < ApplicationController
  before_filter :authenticate_user! :except => [:index, :show]

  def index
  end

  def new
  end

  def show
  end

  def edit
  end
  
  def update
  end

  private
  def book_params
    params.require(:book).permit(:title, :author_last_name, :author_first_name, :isbn, :condition, :status)
end
