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
    trade =  Trade.user_needs_response(@book.user)
    if !trade.empty?
      @trade = trade.first
    else
      @trade = Trade.new  
    end 
    #binding.pry 
    #@current_user = current_user
    if @book.status == "traded"
      redirect_to  :root, notice: "This book is currently not available for trade.  Sorry!"
    end
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
