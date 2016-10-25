class BooksController < ApplicationController
  def new
  end

  def show
  end

  def index
  end

  private
  def book_params
    params.require(:book).permit(:title, :author_last_name, :author_first_name, :isbn, :condition, :status)
end
