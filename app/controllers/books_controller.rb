class BooksController < ApplicationController
  require 'pry'
 
  
  def index_all # localhost:3000/books; if search not entered, returns Book.all where status == 'at home'(i.e. not traded), minus the current_user's books
    search = params[:search]
    if params[:lastid]
      @books = Book.search(search, current_user).where('id > ?', params[:lastid]).limit(5)
    else
      @books = Book.search(search, current_user).limit(5)
    end
    respond_to do |f|
      f.html { render :index }
      f.json { render :json => { :books => @books }}
    end
  end

  def index_users # localhost:3000/users/5/books
    @user = User.find(params[:user_id])
    if @user == current_user
      @mine = current_user.real_name
      the_name = "You don't have "
    else
      @mine = nil
      the_name = "#{@user.real_name.capitalize} hasn't got "
    end
    @books = Book.where(:user_id => (params[:user_id]), :status => 'at_home')
    if @books.empty?
      @books = nil
      @msg = "#{the_name} any books yet!"
    else  
    @msg = "Here are #{@user.real_name}'s books..." 
    end
    respond_to do |f|   
      flash.now[:notice] = @msg
      f.html { render :index }
      f.json { render :json => { :books => @books, :user => @user, :msg => @msg, :mine => @mine }}
    end
  end

  def new
    @genres = Genre.all
    @user = User.find(params[:user_id])
    @book = Book.new
    if @user == current_user && @user.completed_profile?
      respond_to do |f|
        f.html { render :new }
        f.json { render :json => { :book => @book, :user => @user, :genres => @genres.to_json, :only => [:id, :name] } }
      end
    else
      @msg = "You must complete your profile before creating books"
      flash.now[:alert] = @msg
      respond_to do |f|
        f.html { render :edit }
        f.json { render :json => { :msg => @msg }}
      end 
    end
  end

  def create
    @book = Book.new(book_params)
    @user = User.find(params[:user_id])
    @book.user = @user
    if @book.save 
      @msg = "You successfully added a book! Let the nerdfest begin!"
      respond_to do |f|   
        f.html { redirect_to user_books_url, notice: @msg }
        f.json { render :json => { :msg => @msg }}
      end
    else
      @msg = "Book not created! Make sure 'Title' and 'Condition' fields are completed..."  
      flash.now[:alert] = @msg
      respond_to do |f|
        f.html { render :edit }
        f.json { render :json => { :msg => @msg }} 
      end   
    end
  end

  def show #/users/1/books/5
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])
    if @user.visible?
      if @user != current_user && Trade.shared_trade(@user, current_user) #in other words,\
      # if someone else initiated a trade with the current user, 
      #and the current user is now looking at that person's book, considering completing the trade...
        @trade = Trade.shared_trade(@user, current_user) #...this then gives the option of completing the trade in book show view
        @other_trader_rating = Trade.user_rating(@user)
      elsif @user != current_user 
        @trade = Trade.new #this gives the option of initiating a trade in book show view
        @trade.first_trader = current_user
        @other_trader_rating = Trade.user_rating(@user)
      else 
        @trade = nil #in this case the current_user is viewing his/her own title
      end
      respond_to do |f|
        f.html { render :show }
        f.json { render :json => { :book => @book.to_json(include: :genres), :trade => @trade.to_json, :other_trader_rating => @other_trader_rating.to_json }}
      end
    else
      @msg = "This user is not currently active, sorry..."
      flash.now[:notice] = @msg
      respond_to do |f|
        f.html { render :index }
        f.json { render :json => { :msg => @msg }}
      end 
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])
    @genres = Genre.all
    if @user.id == (current_user.id || @user.admin?)
      respond_to do |f|
        f.html { render :edit }
        f.json { render :json => {:book => @book.to_json(include: :genres), :genres => @genres.to_json, :only => [:id, :name] }}
      end 
    else
      @msg = "You don't have permission to edit this book!"
      flash.now[:notice] = @msg
      respond_to do |f|
        f.html { render 'home/logged_in' }
        f.json { render :json => { :msg => @msg }}
      end 
    end
  end
  
  def update
    #binding.pry
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      @book.save 
      @msg = "The book was updated!"
      flash[:notice] = @msg
      respond_to do |f|
        f.html { redirect_to user_books_url }
        f.json { render :json => { :book => @book.to_json(include: :genres), :msg => @msg }}
      end  
    else
      @msg = "The book wasn't updated, sorry!"
      flash.now[:notice] = @msg
      respond_to do |f|
        f.html { render 'home/logged_in' }
        f.json { render :json => { :msg => @msg }}
      end
    end
  end

  def destroy
    @book = Book.find(params[:id])
    user = @book.user
    if user == current_user 
      @book.destroy
      @msg = "The book was deleted!"
      flash[:notice] = @msg
      respond_to do |f|
        f.html { redirect_to user_books_url }
        f.json { render :json => { :msg => @msg }}
      end 
    else
      @msg = "You don't have permission to delete this title, what's wrong with you?!"
      flash.now[:notice] = @msg  
      respond_to do |f|
        f.html { render :books }
        f.json { render :json => { :msg => @msg }}
      end
    end   
  end

  private

  def book_params
    params.require(:book).permit(:user_id, :title, :author_last_name, :author_first_name, :isbn, :condition, :description, :status, :response_id, :request_id, genre_ids:[], genres_attributes: [:name])
  end
end
