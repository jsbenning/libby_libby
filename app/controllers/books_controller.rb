class BooksController < ApplicationController
  before_action :confirm_user_shipworthy, except: [:index_all, :index_users]
  before_action :confirm_user_visible, except: [:index_all]
  

  def index_all # localhost:3000/books; if search not entered, returns Book.all where status == 'at home'(i.e. not traded), minus the current_user's books
    search = params[:search]
    if params[:id]
      @books = Book.search(search, current_user).where('id < ?', params[:id])#.limit(10)
    else
      @books = Book.search(search, current_user)#.limit(10)
    end
    respond_to do |f|
      f.html { render :index }
      f.json { render json: @books}
    end
  end


  def index_users # localhost:3000/users/5/books
    @user = User.find(params[:user_id])
    @books = Book.where(:user_id => (params[:user_id]), :status => 'at_home')
    if @books.empty?
      @books = nil
    end
    respond_to do |f|
      f.html { render :index }
      f.json { render :json => { :books => @book, :user => @user } }
    end
  end

  def new
    @genres = Genre.all
    @user = User.find(params[:user_id])
    @book = Book.new
    respond_to do |f|
      f.html { render :index }
      f.json { render :json => { :book => @book, :user => @user, :genres => @genres } }
    end
  end

   def create
    @book = Book.new(book_params)
    @user = User.find(params[:user_id])
    @book.user = @user
    @msg = "Huzzah!"
    if @book.save
      respond_to do |f|
        flash[:notice] = "You successfully added a book!"
        f.html { redirect_to user_books_url }
        f.json { render :json => { :message => @msg }}
      end 
    else
      @msg = "Yikes!"
      flash.now[:notice] = "Some necessary field is missing!" 
      respond_to do |f|
        f.html { render 'edit' }
        f.json { render :json => { :message => @msg }} 
      end 
    end
  end

  def show #/users/1/books/5
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])
    if @user != current_user && Trade.shared_trade(current_user, @user) #in other words, if someone else initiated a trade with the current user, 
    #and the current user is now looking at that person's book, considering completing the trade
      @trade = Trade.shared_trade(current_user, @user) #this gives the option of completing the trade in book show view
    else
      @trade = Trade.new #this gives the option of creating a trade in book show view
    end
    respond_to do |f|
      f.html { render :show }
      f.json { render :json => { :book => @book, :trade => @trade } }
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

  def confirm_user_visible
    @user = User.find(params[:user_id])
    unless @user.visible
      flash[:notice] = "Requested user is not currently active!"
      render :root
    end
  end


  def confirm_user_shipworthy
    @user = User.find(params[:user_id])
    unless @user.shipworthy?
      flash[:notice] = "Make sure your profile is complete before adding books!"
      render template: 'users/edit'
    end
  end

  def book_params
    params.require(:book).permit(:user_id, :title, :author_last_name, :author_first_name, :isbn, :condition, :description, :status, genre_ids:[], genres_attributes: [:name])
  end
end
