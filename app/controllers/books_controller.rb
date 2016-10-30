class BooksController < ApplicationController
  before_filter :authenticate_user!, :except => [:index_all, :show]

  def index_all
    @books = Book.where(:status => 'at_home')
    render :index
  end

  def index_users
    @books = Book.where(:user_id => (params[:user_id]), :status => 'at_home')
    @list_owner = current_user
    render :index
  end

  def new
  end

  def show
    @book = Book.find(params[:id])
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
