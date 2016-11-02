class BooksController < ApplicationController
  before_filter :authenticate_user!, :except => [:index_all, :show]

  def index_all
    @books = Book.where(:status => 'at_home').where.not(:user_id => current_user.id)
    render :index
  end

  def index_users
    @books = Book.where(:user_id => (params[:user_id]), :status => 'at_home')
    @list_owner = current_user
    render :index
  end

  def new
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @current_user = current_user
  end

  def edit
  end
  
  def update
  end

  def destroy
    @book = Book.find(params[:id])
    if @book.user == current_user
      @book = nil
      redirect_to root_url, notice: 'Book deleted!'
    else
      render :root, notice: "You don't have permission to delete this title!"
    end   
  end

  private

  def book_params
    params.require(:book).permit(:title, :author_last_name, :author_first_name, :isbn, :condition, :status)
  end
end
