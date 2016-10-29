class BooksController < ApplicationController
  before_filter :authenticate_user! :except => [:index, :show]

  def index_all
    @books = Book.all
    render :index
  end

  def index_users
    @books = Book.find_by_user_id(params[:user_id])
    render :index
  end

  def new
  end

  def show
    @book = Boook.find(params[:id])
  end

  def edit
  end
  
  def update
  end

  private

  def book_params
    params.require(:book).permit(:title, :author_last_name, :author_first_name, :isbn, :condition, :status)
  end
end
