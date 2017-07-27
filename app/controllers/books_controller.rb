class BooksController < ApplicationController
  #before_action :authenticate_user!#, :except => [:index_all, :index_users, :show]
  before_action :validate_user_shipworthiness, except: [:index_all, :index_users]



# YIKES!  Needs work, Love --- the guy who wrote it

  def index_all # localhost:3000/books; if search not entered, returns Book.all where status == 'at home'(i.e. not traded), minus the current_user's books
    search = params[:search]
    if params[:id]
      @books = Book.search(search, current_user).where('id < ?', params[:id]).limit(10)
    else
      @books = Book.search(search, current_user).limit(5)
    end
    respond_to do |f|
      f.html { render :index }
      f.json { render json: @books}
    end
  end


  def index_users # localhost:3000/users/5/books
    @user = User.find(params[:user_id])
    @books = Book.where(:user_id => (params[:user_id]), :status => 'at_home')
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
    if @book.save
      flash[:notice] = "You successfully added a book!"
      redirect_to user_books_url
    else
      flash[:notice] = "Some necessary field is missing!" 
      render 'edit' 
    end
  end

  def show #/users/1/books/5
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])
    respond_to do |f|
      f.html { render :show }
      f.json { render json: @book}
    end

    # if @user != current_user && Trade.shared_trade(current_user, @user) #what was I doing here?
    #   @shared_trade = Trade.shared_trade(current_user, @user)
    # else
    #   @new_trade = Trade.new
    # end
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

  def validate_user_shipworthiness
    @user = User.find(params[:user_id])
    unless @user.shipworthy?
      flash[:notice] = "Make sure your profile is complete before adding books!"
      render "users/#{current_user.id}/edit"
    end
  end

  def book_params
    params.require(:book).permit(:user_id, :title, :author_last_name, :author_first_name, :isbn, :condition, :description, :status, genre_ids:[], genres_attributes: [:name])
  end
end
