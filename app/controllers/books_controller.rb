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
    @user = User.find(params[:user_id])
    @book = Book.new
  end

   def create
    @book = Book.new(book_params)
    if @book.save
      flash[:notice] = "Successfully created book!"
      redirect_to user_books_url
    else
      render :root
    end     
  end

  def show
    @book = Book.find(params[:id])
    trade =  Trade.user_needs_response(@book.user)
    if !trade.empty?
      @trade = trade.first
    else
      @trade = Trade.new  
    end 
    if @book.status == "traded"
      redirect_to  :root, notice: "This book is currently not available for trade.  Sorry!"
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])

  end
  
  def update
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to :index_users, notice: "Book updated!"
    else
    render :root, notice: "Book not updated!" 
    end
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
    params.require(:book).permit(:title, :author_last_name, :author_first_name, :isbn, :condition, :status, genre_ids:[], genres_attributes: [:name])
  end
end
