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
      f.json { render :json => { :books => @books }}
    end
  end

  def index_users # localhost:3000/users/5/books
    @user = User.find(params[:user_id])
    if @user == current_user
      the_name = "You don't have "
    else
      the_name = "#{@user.first_name.capitalize} hasn't got "
    end
    @books = Book.where(:user_id => (params[:user_id]), :status => 'at_home')
    if @books.empty?
      @books = nil
      @msg = "#{the_name} any books yet!"
    else
    @msg = "Here are #{@user.first_name}'s books..." 
    end
    respond_to do |f|   
      flash.now[:notice] = @msg
      f.html { render :index }
      f.json { render :json => { :books => @books, :user => @user, :msg => @msg }}
    end
  end

  def new
    @genres = Genre.all
    @user = User.find(params[:user_id])
    @book = Book.new
    respond_to do |f|
      f.html { render :new }
      f.json { render :json => { :book => @book, :user => @user, :genres => @genres } }
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
      @msg = "Some necessary field is missing.  Well don't look at me, I don't understand computers!"  
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
    if @user != current_user && Trade.shared_trade(current_user, @user) #in other words, if someone else initiated a trade with the current user, 
    #and the current user is now looking at that person's book, considering completing the trade...
      @trade = Trade.shared_trade(current_user, @user) #...this then gives the option of completing the trade in book show view
      @other_trader_rating = Trade.user_rating(@user)
    elsif @user != current_user
      @trade = Trade.new #this gives the option of initiating a trade in book show view
      @other_trader_rating = Trade.user_rating(@user)
    else 
      @trade = nil #in this case the current_user is viewing his/her own title
    end
    respond_to do |f|
      f.html { render :show }
      f.json { render :json => { :book => @book.to_json(include: :genres), :trade => @trade.to_json, :other_trader_rating => @other_trader_rating.to_json }}
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
        #f.json { render :json => {:book => @book.to_json(include: :genres, :only => [:id, :name]), :genres => @genres }}#{ render :json => { :book => @book, :genres => @genres }}
      end 
    else
      flash.now[:notice] = "You don't have permission to edit this book!"
      @msg = "You don't have permission to edit this book!"
      respond_to do |f|
        f.html { render :index }
        f.json { render :json => { :msg => @msg }}
      end 
    end
  end
  
  def update
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])
    if @user.id == (current_user.id || @user.admin?) && @book.update_attributes(book_params)
      flash[:notice] = "The book was updated!"
      @msg = "The book was updated!"
      respond_to do |f|
        f.html { redirect_to user_books_url }
        f.json { render :json => { :msg => @msg }}
      end  
    else
      @msg = "The book wasn't updated, sorry!"
      flash.now[:notice] = @msg
      respond_to do |f|
        f.html { render :books }
        f.json { render :json => { :msg => @msg }}
      end
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @book = Book.find(params[:id])
    if @user.id == (current_user.id || @user.admin?)
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

  def confirm_user_visible
    @user = User.find(params[:user_id])
    unless @user.visible
      flash[:notice] = "The requested user is not currently active. They're hiding or ... they've been hidden(shudder)!"
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
