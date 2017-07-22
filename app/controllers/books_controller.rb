class BooksController < ApplicationController
  before_action :authenticate_user!#, :except => [:index_all, :index_users, :show]


  def index_all
    search = params[:search]
    @books = Book.search(search, current_user)
    render :index
  end

  def index_users
    @user = User.find(params[:user_id])
    if @user == current_user
      @books = Book.where(:user_id => (params[:user_id]), :status => 'at_home')
    else
      @books = Book.where(:user_id => (params[:user_id]), :status => 'at_home')
    end
    render :index
  end

  def new
    @user = User.find(params[:user_id])
    @book = Book.new
  end

   def create
    @book = Book.new(book_params)
    @user = User.find(params[:user_id])
    @book.user = @user
    if @user.shipworthy? && @book.save
      flash[:notice] = "You successfully added a book!"
      redirect_to user_books_url
    else
      flash.now[:notice] = "The book wasn't added --- Make sure your shipping info is completed!"
      render 'users/edit'
    end     
  end

  def show
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])
    @current_user = current_user
    if @user != current_user && Trade.shared_trade(@current_user, @user)
      @shared_trade = Trade.shared_trade(@current_user, @user)
    else
      @new_trade = Trade.new
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])
  end
  
  def update
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      flash[:notice] = "The book was updated!"
      redirect_to user_books_url
    else
      flash.now[:notice] = "The book wasn't updated, sorry!" 
    render :root
    end
  end

  def destroy
    @book = Book.find(params[:id])
    if @book.user == current_user || current_user.admin?
      @book.destroy
      flash[:notice] = "The book was deleted!"
      redirect_to user_books_url
    else
      flash.now[:notice] = "You don't have permission to delete this title, sorry!"
      render :root
    end   
  end

  private

  def book_params
    params.require(:book).permit(:user_id, :title, :author_last_name, :author_first_name, :isbn, :condition, :description, :status, genre_ids:[], genres_attributes: [:name])
  end
end
